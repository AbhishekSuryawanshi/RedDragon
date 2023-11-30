//
//  HomePredictionViewController.swift
//  RedDragon
//
//  Created by Ali on 11/21/23.
//

import UIKit
import Combine
import SDWebImage

class HomePredictionViewController: UIViewController {

    @IBOutlet weak var sportsCollectionView: UICollectionView!
    @IBOutlet weak var predictionsTimeLbl3: UILabel!
    @IBOutlet weak var predictionsTeamWinLbl3: UILabel!
    @IBOutlet weak var predictionsTeam2Lbl3: UILabel!
    @IBOutlet weak var predictionsdateLbl3: UILabel!
    @IBOutlet weak var predictionsTeam1Lbl3: UILabel!
    @IBOutlet weak var predictionsLeagueNameLbl3: UILabel!
    @IBOutlet weak var predictionsLeagueImgView3: UIImageView!
    @IBOutlet weak var predictionsTimeLbl2: UILabel!
    @IBOutlet weak var predictionsTeamWinLbl2: UILabel!
    @IBOutlet weak var predictionsTeam2Lbl2: UILabel!
    @IBOutlet weak var predictionsdateLbl2: UILabel!
    @IBOutlet weak var predictionTeam1Lbl2: UILabel!
    @IBOutlet weak var predictionsLeagueLbl2: UILabel!
    @IBOutlet weak var predictionsLeagueImgView2: UIImageView!
    @IBOutlet weak var predictionsTimeLbl1: UILabel!
    @IBOutlet weak var predictionsTeamWinLbl1: UILabel!
    @IBOutlet weak var predictionsTeam2Lbl1: UILabel!
    @IBOutlet weak var predictionsdateLbl1: UILabel!
    @IBOutlet weak var predictionsTeam1Lbl1: UILabel!
    @IBOutlet weak var predictionsLeagueNameLbl1: UILabel!
    @IBOutlet weak var predictionsLeagueImgView1: UIImageView!
    @IBOutlet weak var seeAllPlacedPredictionsBtn: UIButton!
    @IBOutlet weak var placedPredictionsLbl: UILabel!
    @IBOutlet weak var upcomingteam2Lbl3: UILabel!
    @IBOutlet weak var upcomingdateLbl3: UILabel!
    @IBOutlet weak var upcomingTeam1Lbl3: UILabel!
    @IBOutlet weak var upcomingPredictBtn3: UIButton!
    @IBOutlet weak var upcomingLeagueNameLbl3: UILabel!
    @IBOutlet weak var upcomingLeagueImgView3: UIImageView!
    @IBOutlet weak var upcomingTeam2Lbl2: UILabel!
    @IBOutlet weak var upcomingdateLbl2: UILabel!
    @IBOutlet weak var upcomingTeam1Lbl2: UILabel!
    @IBOutlet weak var upcomingPredictBtn2: UIButton!
    @IBOutlet weak var upcomingLeagueNameLbl2: UILabel!
    @IBOutlet weak var upcomingLeagueImgView2: UIImageView!
    @IBOutlet weak var upcomingTeam2Lbl1: UILabel!
    @IBOutlet weak var upcomingdateLbl1: UILabel!
    @IBOutlet weak var upcomingTeam1Lbl1: UILabel!
    @IBOutlet weak var upcomingPredictBtn1: UIButton!
    @IBOutlet weak var upcomingLeagueNameLbl1: UILabel!
    @IBOutlet weak var upcomingLeagueImgView1: UIImageView!
    @IBOutlet weak var seeAllBtn: UIButton!
    @IBOutlet weak var upcomingMatchesLbl: UILabel!
    @IBOutlet weak var sportsSelectionView: UIView!
    @IBOutlet weak var predictionTopView: TopView!
    
    var sportsArr = ["football" , "basketball"]
    var selectedMatch: PredictionData?
    private var predictionMatchesViewModel: PredictionViewModel?
    private var predictionListUserViewModel:PredictionsListUserViewModel?
    var predictionsModel: PredictionMatchesModel?
    var predictionListUserModel: PredictionListModel?
    private var cancellable = Set<AnyCancellable>()
    var selectedSports = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = #colorLiteral(red: 0.7333333333, green: 0.09803921569, blue: 0.06274509804, alpha: 1)
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func configureView() {
        selectedSports = sportsArr[0]
        loadFunctionality()
        fetchPredictionMatchesViewModel()
        makeNetworkCall(sport: selectedSports)
        
        
    }
    
    func loadFunctionality() {
        nibInitialization()
    }
    
    func nibInitialization() {
        sportsCollectionView.register(CellIdentifier.leagueNamesCollectionCell)
        sportsCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .left)
        selectedSports = sportsArr[0]
        
    }
    
    func makeNetworkCall(sport: String) {
        predictionMatchesViewModel?.fetchPredictionMatchesAsyncCall(lang: "en", date: Date().formatDate(outputFormat: dateFormat.yyyyMMdd), sportType: sport)
    }
    
    func makeNetworkCall2(sport: String) {
        predictionListUserViewModel?.fetchPredictionUserListAsyncCall(appUserID: "7", sportType: sport)  // To give logged in user id instead of 7
    }
    func showLoader(_ value: Bool) {
        value ? Loader.activityIndicator.startAnimating() : Loader.activityIndicator.stopAnimating()
    }
    
    @objc func predictBtn1(){
        navigateToViewController(PredictionDetailsViewController.self, storyboardName: StoryboardName.prediction) { vc in
            vc.sport = self.selectedSports
            self.selectedMatch = self.predictionMatchesViewModel?.responseData?.data?[self.upcomingPredictBtn1.tag]
            vc.selectedMatch = self.selectedMatch
                }
    }
    
    @objc func predictBtn2(){
        navigateToViewController(PredictionDetailsViewController.self, storyboardName: StoryboardName.prediction) { vc in
            vc.sport = self.selectedSports
            self.selectedMatch = self.predictionMatchesViewModel?.responseData?.data?[self.upcomingPredictBtn2.tag]
            vc.selectedMatch = self.selectedMatch
                }
    }
    
    @objc func predictBtn3(){
        navigateToViewController(PredictionDetailsViewController.self, storyboardName: StoryboardName.prediction) { vc in
            vc.sport = self.selectedSports
            self.selectedMatch = self.predictionMatchesViewModel?.responseData?.data?[self.upcomingPredictBtn3.tag]
            vc.selectedMatch = self.selectedMatch
        }
    }
    
    @objc func upcomingSeeAll(){
        navigateToViewController(UpComingMatchesViewController.self, storyboardName: StoryboardName.prediction) { vc in
            vc.selectedSports = self.selectedSports
            vc.predictionMatchesModel = self.predictionsModel
        }
    }
    
    @objc func placedPredictionSeeAll(){
        
    }

}

extension HomePredictionViewController {
    ///fetch viewModel for match prediction
    func fetchPredictionMatchesViewModel() {
        predictionMatchesViewModel = PredictionViewModel()
        predictionMatchesViewModel?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        predictionMatchesViewModel?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        predictionMatchesViewModel?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] data in
                self?.renderResponseData(data: data!)
            })
            .store(in: &cancellable)
    }
    
    func renderResponseData(data: PredictionMatchesModel) {
        fetchPredictionUserListViewModel()
        makeNetworkCall2(sport: selectedSports)
        predictionsModel = data
        let data = data.data
        UIView.animate(withDuration: 1.0) { [self] in
            upcomingLeagueNameLbl1.text = data?[0].league
            upcomingLeagueImgView1.sd_imageIndicator = SDWebImageActivityIndicator.white
            upcomingLeagueImgView1.sd_setImage(with: URL(string: data?[0].logo ?? ""))
            upcomingTeam1Lbl1.text = data?[0].matches?[0].homeTeam
            upcomingTeam2Lbl1.text = data?[0].matches?[0].awayTeam
            upcomingdateLbl1.text = Date().formatDate(outputFormat: dateFormat(rawValue: "yyyy-MM-dd")!) + " | " + (data?[0].matches?[0].time ?? "")
            upcomingPredictBtn1.tag = 0
            
            upcomingPredictBtn1.addTarget(self, action: #selector(predictBtn1), for: .touchUpInside)
            seeAllBtn.addTarget(self, action: #selector(upcomingSeeAll), for: .touchUpInside)
            
            if data?[1] != nil{
                upcomingLeagueNameLbl2.text = data?[1].league
                upcomingLeagueImgView2.sd_imageIndicator = SDWebImageActivityIndicator.white
                upcomingLeagueImgView2.sd_setImage(with: URL(string: data?[1].logo ?? ""))
                upcomingTeam1Lbl2.text = data?[1].matches?[0].homeTeam
                upcomingTeam2Lbl2.text = data?[1].matches?[0].awayTeam
                upcomingdateLbl2.text = Date().formatDate(outputFormat: dateFormat(rawValue: "yyyy-MM-dd")!) + " | " + (data?[1].matches?[0].time ?? "")
                upcomingPredictBtn2.tag = 1
                upcomingPredictBtn2.addTarget(self, action: #selector(predictBtn2), for: .touchUpInside)
            }
            if data?[2] != nil{
                upcomingLeagueNameLbl3.text = data?[2].league
                upcomingLeagueImgView3.sd_imageIndicator = SDWebImageActivityIndicator.white
                upcomingLeagueImgView3.sd_setImage(with: URL(string: data?[2].logo ?? ""))
                upcomingTeam1Lbl3.text = data?[2].matches?[0].homeTeam
                upcomingteam2Lbl3.text = data?[2].matches?[0].awayTeam
                upcomingdateLbl3.text = Date().formatDate(outputFormat: dateFormat(rawValue: "yyyy-MM-dd")!) + " | " + (data?[2].matches?[0].time ?? "")
                upcomingPredictBtn3.tag = 2
                upcomingPredictBtn3.addTarget(self, action: #selector(predictBtn3), for: .touchUpInside)
            }
                
        }
        
    }
    
    func fetchPredictionUserListViewModel() {
        predictionListUserViewModel = PredictionsListUserViewModel()
        predictionListUserViewModel?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        predictionListUserViewModel?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        predictionListUserViewModel?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] data in
                self?.renderResponseData(data: data!)
            })
            .store(in: &cancellable)
    }
    
    func renderResponseData(data: PredictionListModel) {
        predictionListUserModel = data
        let data = data.data
        UIView.animate(withDuration: 1.0) { [self] in
            predictionsLeagueNameLbl1.text = data?[0].matchDetail.leagueName
            predictionsLeagueImgView1.sd_imageIndicator = SDWebImageActivityIndicator.white
           // predictionsLeagueImgView1.sd_setImage(with: URL(string: data?[0].matchDetail[0].logo ?? ""))
            predictionsTeam1Lbl1.text = data?[0].matchDetail.homeTeamName
            predictionsTeam2Lbl1.text = data?[0].matchDetail.awayTeamName
            predictionsdateLbl1.text =  data?[0].matchDetail.matchDatetime
          //  upcomingPredictBtn1.tag = 0
            
          //  upcomingPredictBtn1.addTarget(self, action: #selector(predictBtn1), for: .touchUpInside)
            seeAllBtn.addTarget(self, action: #selector(placedPredictionSeeAll), for: .touchUpInside)
            if data?.count ?? 0 > 1{
                if data?[1] != nil{
                    predictionsLeagueLbl2.text = data?[1].matchDetail.leagueName
                    predictionsLeagueImgView2.sd_imageIndicator = SDWebImageActivityIndicator.white
                    // predictionsLeagueImgView1.sd_setImage(with: URL(string: data?[0].matchDetail[0].logo ?? ""))
                    predictionTeam1Lbl2.text = data?[1].matchDetail.homeTeamName
                    predictionsTeam2Lbl2.text = data?[1].matchDetail.awayTeamName
                    predictionsdateLbl2.text =  data?[1].matchDetail.matchDatetime
                }
                if data?[2] != nil{
                    predictionsLeagueNameLbl3.text = data?[2].matchDetail.leagueName
                    predictionsLeagueImgView3.sd_imageIndicator = SDWebImageActivityIndicator.white
                    // predictionsLeagueImgView1.sd_setImage(with: URL(string: data?[0].matchDetail[0].logo ?? ""))
                    predictionsTeam1Lbl3.text = data?[2].matchDetail.homeTeamName
                    predictionsTeam2Lbl3.text = data?[2].matchDetail.awayTeamName
                    predictionsdateLbl3.text =  data?[2].matchDetail.matchDatetime
                }
                
            }
                
        }
        
    }
}

extension HomePredictionViewController {
    func addActivityIndicator() {
        self.view.addSubview(Loader.activityIndicator)
    }
    
    func configureUI() {
        addActivityIndicator()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func configureLanguage() {
        var lang = UserDefaults.standard.string(forKey: UserDefaultString.language) ?? "en"
        lang = (lang == "en-US") ? "en" : lang
        // fetchCurrentLanguageCode = lang
    }
}
    


extension HomePredictionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sportsArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.leagueNamesCollectionCell, for: indexPath) as! LeagueCollectionViewCell
        cell.leagueName.text = sportsArr[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        fetchPredictionMatchesViewModel()
        selectedSports = sportsArr[indexPath.row]
        makeNetworkCall(sport: selectedSports)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth / 2, height: 15)
    }
    
    
    
}


