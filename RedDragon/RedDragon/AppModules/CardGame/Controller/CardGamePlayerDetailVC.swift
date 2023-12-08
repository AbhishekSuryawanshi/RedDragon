//
//  CardGamePlayerDetailVC.swift
//  RedDragon
//
//  Created by QASR02 on 22/11/2023.
//

import UIKit
import Toast
import Hero
import Combine
import SDWebImage
import DDSpiderChart

class CardGamePlayerDetailVC: UIViewController {
    
    @IBOutlet weak var userPointsLabel: UILabel!
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var positionLabelView: UIView!
    @IBOutlet weak var ratingPercentCountLabel: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var playerDetailLabel: UILabel!
    @IBOutlet weak var aboutDataLabel: UILabel!
    @IBOutlet weak var countryImageView: UIImageView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var teamLogoImageView: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var marketPriceLabel: UILabel!
    @IBOutlet weak var priceNumberLabel: UILabel!
    @IBOutlet weak var playerSkillView: SpiderChartView!
    @IBOutlet weak var statCollectionView: UICollectionView!
    @IBOutlet weak var buyButton: UIButton!
    
    var cancellable = Set<AnyCancellable>()
    var playerDetailVM: PlayerDetailViewModel?
    var lang = String()
    var slug = String()
    var defaultImage = String()
    var playerName = String()
    var position = String()
    var value = String()
    var skillArr:[String?] = []
    var skillVal:[String?] = []
    var skillNum: [Float] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        loadFunctionality()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
    }
    
    private func loadFunctionality() {
        nibInitialization()
        addActivityIndicator()
        fetchPlayerViewModel()
    }
    
    private func nibInitialization() {
        statCollectionView.register(CellIdentifier.statisticCell)
    }
    
    private func makeNetworkCall() {
        lang = UserDefaults.standard.string(forKey: UserDefaultString.language) ?? "en"
        lang = (lang.contains("zh")) ? "zh" : "en"
        playerDetailVM?.fetchPlayerDetailAsyncCall(lang: lang, slug: slug)
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buyPlayerButton(_ sender: Any) {
        print(UserDefaults.standard.token as Any)
        print(UserDefaults.standard.budget as Any)
        if ((UserDefaults.standard.token ?? "") != "") {
            let marketValue = Int(value)
            presentToViewController(BuyPlayerViewController.self, storyboardName: StoryboardName.cardGamePopup, animationType: .fade) { [self] vc in
                vc.image = defaultImage
                vc.name = playerName
                vc.position = position
                vc.value = formatNumber(Double(marketValue ?? 0))
                vc.slug = playerDetailVM?.responseData?.data?.teamSlug
                vc.playerID = playerDetailVM?.responseData?.data?.playerID
            }
        } else {
            customAlertView(title: ErrorMessage.alert.localized, description: ErrorMessage.loginRequires.localized, image: ImageConstants.alertImage)
        }
    }
}

/// __fetch Players View model
extension CardGamePlayerDetailVC {
    
    private func fetchPlayerViewModel() {
        playerDetailVM = PlayerDetailViewModel()
        playerDetailVM?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        playerDetailVM?.showError = { [weak self] error in
            self?.view.makeToast(ErrorMessage.dataNotFound.localized, duration: 2.0, position: .center)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self?.navigationController?.popViewController(animated: true)
            }
        }
        playerDetailVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] details in
                self?.statCollectionView.reloadData()
                self?.presentData()
            })
            .store(in: &cancellable)
        
        makeNetworkCall()
    }
    
    private func presentData() {
        guard let data = playerDetailVM?.responseData?.data else { return }
        
        updateTeamInto(data: data)
        updateMarketAndRating(data: data)
        configureChartsView()
    }
    
    private func updateTeamInto(data: PlayerDetailData) {
        teamLogoImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        teamLogoImageView.sd_setImage(with: URL(string: data.teamPhoto ?? ""))
        teamNameLabel.text = data.teamName
        countryNameLabel.text = data.playerCountry?.capitalized
        aboutDataLabel.text = data.about
        countryImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        countryImageView.sd_setImage(with: URL(string: "http://157.245.159.136:5072/flags/flag.php?flag=" + (data.playerCountry ?? "")))
    }
    
    private func updateMarketAndRating(data: PlayerDetailData) {
        let marketingKey = (lang.contains("zh")) ? "市场价" : "Market price"
        if let marketPriceData = data.indicators?.first(where: { $0.key == marketingKey }) {
            priceNumberLabel.text = marketPriceData.value
            //marketValuePrice_aboutPlayer_label.text = marketPriceData.value
        }
        let ratingKey = (lang.contains("zh")) ? "评分" : "Rating"
        if let ratingData = data.indicators?.first(where: { $0.key == ratingKey }) {
            ratingPercentCountLabel.text = ratingData.value
        }
    }
}

/// __Supportive function
extension CardGamePlayerDetailVC {
    
    private func addActivityIndicator() {
        self.view.addSubview(Loader.activityIndicator)
    }
    
    private func showLoader(_ value: Bool) {
        value ? Loader.activityIndicator.startAnimating() : Loader.activityIndicator.stopAnimating()
    }
    
    private func updateUI() {
        playerImageView.heroID = defaultImage
        playerNameLabel.heroID = playerName
        
        let userBudget = UserDefaults.standard.budget
        userPointsLabel.text = "\(formatNumber(Double(userBudget!)))"
        
        playerImageView.sd_imageIndicator = SDWebImageActivityIndicator.white
        playerImageView.sd_setImage(with: URL(string: defaultImage))
        playerNameLabel.text = playerName
        positionLabel.text = position
        labelRoundedCorner()
        
        let marketValue = Int(value)
        let value = formatNumber(Double(marketValue ?? 0))
        buyButton.setTitle("Buy for \(value)", for: .normal)
    }
    
    private func labelRoundedCorner() {
        positionLabelView.borderColor = #colorLiteral(red: 0.7895337343, green: 0.174926281, blue: 0.06877139956, alpha: 1)
        positionLabelView.borderWidth = 1.0
        positionLabelView.layer.cornerRadius = 13
        positionLabelView.clipsToBounds = true
        ratingView.borderColor = #colorLiteral(red: 0.7895337343, green: 0.174926281, blue: 0.06877139956, alpha: 1)
        ratingView.borderWidth = 1.0
        ratingView.layer.cornerRadius = 13
        ratingView.clipsToBounds = true
    }
    
    /// __Configure Spider chart view
    private func configureChartsView() {
        for i in 0 ..< (playerDetailVM?.responseData?.data?.rating?.count ?? 0){
            skillArr.append("\(playerDetailVM?.responseData?.data?.rating?[i].value ?? "") " + "\(playerDetailVM?.responseData?.data?.rating?[i].key ?? "")")
            skillVal.append(playerDetailVM?.responseData?.data?.rating?[i].value)
        }
        skillsChartFunction()
    }
    
    private func skillsChartFunction() {
        let spiderChartView = DDSpiderChartView(frame: CGRect(x: 0, y: 50, width: screenWidth - 20, height: 350)) // Replace with some frame or add constraints
        spiderChartView.axes = skillArr.map {
            attributedAxisLabel($0 ?? "") } // Set axes by giving their labels
        spiderChartView.addDataSet(values: removeCharacterFromString(valArr: skillVal), color: UIColor.yellow1, animated: true) // Add first data set
        spiderChartView.backgroundColor = .white
        playerSkillView.spiderView.color = .gray
        playerSkillView.backgroundColor = .white
        playerSkillView.addSubview(spiderChartView)
    }
    
    private func attributedAxisLabel(_ label: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        let gillsansFont = UIFont(name: "GillSans", size: 14) ?? UIFont.systemFont(ofSize: 14)
        attributedString.append(NSAttributedString(string: label, attributes:
                                                    [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                     NSAttributedString.Key.font: gillsansFont,
                                                     NSAttributedString.Key.backgroundColor: #colorLiteral(red: 1, green: 0.8549019608, blue: 0.8352941176, alpha: 1) ]))
        return attributedString
    }
    
    private func removeCharacterFromString(valArr: [String?]) -> [Float]{
        var val = ""
        for i in 0 ..< valArr.count{
            val = valArr[i]?.replacingOccurrences(of: "%", with: "") ?? ""
            skillNum.append(((Float(val) ?? 0.0)/100.0))
        }
        return skillNum
    }
}

extension CardGamePlayerDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playerDetailVM?.responseData?.data?.statistics?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let data = playerDetailVM?.responseData else { return UICollectionViewCell() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.statisticCell, for: indexPath) as! StatCollectionViewCell
        cell.configuration(with: data, cellForItemAt: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width/1 - 0, height: 280)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        animateCollectionView(collectionView, willDisplay: cell, forItemAt: indexPath, animateDuration: 0.4)
    }
}
