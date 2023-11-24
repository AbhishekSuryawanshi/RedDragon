//
//  CardGamePlayerDetailVC.swift
//  RedDragon
//
//  Created by QASR02 on 22/11/2023.
//

import UIKit
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
        addActivityIndicator()
        fetchPlayerViewModel()
    }
    
    private func makeNetworkCall() {
        lang = UserDefaults.standard.string(forKey: UserDefaultString.language) ?? "en"
        lang = (lang.contains("zh")) ? "zh" : "en"
        playerDetailVM?.fetchPlayerDetailAsyncCall(lang: lang, slug: slug)
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        playerDetailVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] details in
                print(details as Any)
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
//        updatePlayerRating(data: data)
//        updateCosmosView(data: data)
//        
//        leagueCountLabel.text = "\(data.statistics.count)"
//        numberOfLeagues_countLabel.text = "\(data.statistics.count)"
        
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
        
        playerImageView.sd_imageIndicator = SDWebImageActivityIndicator.white
        playerImageView.sd_setImage(with: URL(string: defaultImage))
        playerNameLabel.text = playerName
        positionLabel.text = position
        labelRoundedCorner()
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
