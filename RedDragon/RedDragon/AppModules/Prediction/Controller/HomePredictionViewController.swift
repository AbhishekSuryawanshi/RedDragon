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
    
    @IBOutlet weak var userPredictionTitleLbl: UILabel!
    @IBOutlet weak var upcomingMatchesStackView: UIStackView!
    @IBOutlet weak var placedPredictionView3: UIView!
    @IBOutlet weak var placedPredictionView2: UIView!
    @IBOutlet weak var placedPredictionView1: UIView!
    @IBOutlet weak var placedPredictionsStackView: UIStackView!
    @IBOutlet weak var sportsCollectionView: UICollectionView!
    @IBOutlet weak var predictionsTimeLbl3: UILabel!
    @IBOutlet weak var predictionsTeamWinLbl3: UILabel!
    @IBOutlet weak var predictionsTeam2Lbl3: UILabel!
    @IBOutlet weak var predictionsdateLbl3: UILabel!
    @IBOutlet weak var predictionsTeam1Lbl3: UILabel!
    @IBOutlet weak var predictionsLeagueNameLbl3: UILabel!
    
    @IBOutlet weak var predictionsTeam2ImgView3: UIImageView!
    @IBOutlet weak var predictionsTeam1ImgView3: UIImageView!
    @IBOutlet weak var predictionsTimeLbl2: UILabel!
    @IBOutlet weak var predictionsTeamWinLbl2: UILabel!
    @IBOutlet weak var predictionsTeam2Lbl2: UILabel!
    @IBOutlet weak var predictionsdateLbl2: UILabel!
    @IBOutlet weak var predictionTeam1Lbl2: UILabel!
    @IBOutlet weak var predictionsLeagueLbl2: UILabel!
    
    @IBOutlet weak var predictionsTeam2ImgView2: UIImageView!
    @IBOutlet weak var predictionsTeam1ImgView2: UIImageView!
    @IBOutlet weak var predictionsTimeLbl1: UILabel!
    @IBOutlet weak var predictionsTeamWinLbl1: UILabel!
    @IBOutlet weak var predictionsTeam2Lbl1: UILabel!
    @IBOutlet weak var predictionsdateLbl1: UILabel!
    @IBOutlet weak var predictionsTeam1Lbl1: UILabel!
    @IBOutlet weak var predictionsLeagueNameLbl1: UILabel!
    
    @IBOutlet weak var predictionsTeam2ImgView1: UIImageView!
    @IBOutlet weak var predictionsTeam1ImgView1: UIImageView!
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
    
    var sportsArr = ["football","basketball"]
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
        userPredictionTitleLbl.text = "User Prediction".localized
        if ((UserDefaults.standard.token ?? "") != "") && ((UserDefaults.standard.user?.otpVerified ?? 0) == 1) {
            removeBlurView()
            let userID = UserDefaults.standard.user?.appDataIDs.predictMatchUserId
            predictionListUserViewModel?.fetchPredictionUserListAsyncCall(appUserID: "\(userID ?? 0)" , sportType: selectedSports, date: "")  // To give logged in user id instead of 7
            predictionTopView.tagsCollectionView.register(CellIdentifier.predictTagCollectionViewCell)
            predictionTopView.tagsCollectionView.delegate = self
            predictionTopView.tagsCollectionView.dataSource = self
            predictionTopView.tagsCollectionView.reloadData()
            predictionTopView.predictionHistoryBtn.addTarget(self, action: #selector(placedPredictionSeeAll), for: .touchUpInside)
            upcomingMatchesLbl.text = "Upcoming Matches".localized
            placedPredictionsLbl.text = "Placed Predictions".localized
            seeAllBtn.setTitle("See all".localized, for: .normal)
            seeAllPlacedPredictionsBtn.setTitle("See all".localized, for: .normal)
        }
        else{
            addBlurView()
        }
        
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
    
    func addBlurView(){
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.tag = 9
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
    
    func removeBlurView(){
        view.viewWithTag(9)?.removeFromSuperview()
    }
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func makeNetworkCall(sport: String) {
        if ((UserDefaults.standard.token ?? "") != "") && ((UserDefaults.standard.user?.otpVerified ?? 0) == 1) {
            predictionTopView.userImgView.setImage(imageStr: UserDefaults.standard.user?.profileImg ?? "")
            predictionTopView.usernameLbl.text = UserDefaults.standard.user?.name
            predictionTopView.walletPointsLbl.text = "Points: ".localized + " \(UserDefaults.standard.user?.wallet ?? 0)"
            
        }
        predictionMatchesViewModel?.fetchPredictionMatchesAsyncCall(lang: UserDefaults.standard.language ?? "en", date: Date().formatDate(outputFormat: dateFormat.yyyyMMdd), sportType: sport)
    }
    
    func makeNetworkCall2(sport: String, date: String) {
        let userID = UserDefaults.standard.user?.appDataIDs.predictMatchUserId
        predictionListUserViewModel?.fetchPredictionUserListAsyncCall(appUserID: "\(userID ?? 0)" , sportType: sport, date: date)  // To give logged in user id instead of 7
        
    }
    func showLoader(_ value: Bool) {
        value ? startLoader() : stopLoader()
    }
    
    @objc func predictBtn1(){
        navigateToViewController(PredictionDetailsViewController.self, storyboardName: StoryboardName.prediction) { vc in
            vc.sport = self.selectedSports
            self.selectedMatch = self.predictionMatchesViewModel?.responseData?.response?.data?[self.upcomingPredictBtn1.tag]
            vc.selectedMatch = self.selectedMatch
        }
    }
    
    @objc func predictBtn2(){
        navigateToViewController(PredictionDetailsViewController.self, storyboardName: StoryboardName.prediction) { vc in
            vc.sport = self.selectedSports
            self.selectedMatch = self.predictionMatchesViewModel?.responseData?.response?.data?[self.upcomingPredictBtn2.tag]
            vc.selectedMatch = self.selectedMatch
        }
    }
    
    @objc func predictBtn3(){
        navigateToViewController(PredictionDetailsViewController.self, storyboardName: StoryboardName.prediction) { vc in
            vc.sport = self.selectedSports
            self.selectedMatch = self.predictionMatchesViewModel?.responseData?.response?.data?[self.upcomingPredictBtn3.tag]
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
        navigateToViewController(PredictionHistoryViewController.self, storyboardName: StoryboardName.prediction){ vc in
            vc.predictionListUserModel = self.predictionListUserModel
            vc.selectedSports = self.selectedSports
        }
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
        makeNetworkCall2(sport: selectedSports, date: "")
        predictionsModel = data
        if let data = data.response?.data{
            UIView.animate(withDuration: 1.0) { [self] in
                if data.count > 0{
                    upcomingLeagueNameLbl1.text = data[0].league?.localized
                    upcomingLeagueImgView1.sd_imageIndicator = SDWebImageActivityIndicator.white
                    upcomingLeagueImgView1.sd_setImage(with: URL(string: data[0].logo ?? ""))
                    upcomingTeam1Lbl1.text = data[0].matches?[0].homeTeam?.localized
                    upcomingTeam2Lbl1.text = data[0].matches?[0].awayTeam?.localized
                    upcomingdateLbl1.text = Date().formatDate(outputFormat: dateFormat(rawValue: "yyyy-MM-dd")!) + " | " + (data[0].matches?[0].time ?? "")
                    upcomingPredictBtn1.tag = 0
                    upcomingPredictBtn1.setTitle("Predict".localized, for: .normal)
                    upcomingPredictBtn1.addTarget(self, action: #selector(predictBtn1), for: .touchUpInside)
                    seeAllBtn.addTarget(self, action: #selector(upcomingSeeAll), for: .touchUpInside)
                    
                    if data.count > 1{
                        upcomingLeagueNameLbl2.text = data[1].league
                        upcomingLeagueImgView2.sd_imageIndicator = SDWebImageActivityIndicator.white
                        upcomingLeagueImgView2.sd_setImage(with: URL(string: data[1].logo ?? ""))
                        upcomingTeam1Lbl2.text = data[1].matches?[0].homeTeam
                        upcomingTeam2Lbl2.text = data[1].matches?[0].awayTeam
                        upcomingdateLbl2.text = Date().formatDate(outputFormat: dateFormat(rawValue: "yyyy-MM-dd")!) + " | " + (data[1].matches?[0].time ?? "")
                        upcomingPredictBtn2.tag = 1
                        upcomingPredictBtn2.setTitle("Predict".localized, for: .normal)
                        upcomingPredictBtn2.addTarget(self, action: #selector(predictBtn2), for: .touchUpInside)
                    }
                    if data.count > 2{
                        upcomingLeagueNameLbl3.text = data[2].league
                        upcomingLeagueImgView3.sd_imageIndicator = SDWebImageActivityIndicator.white
                        upcomingLeagueImgView3.sd_setImage(with: URL(string: data[2].logo ?? ""))
                        upcomingTeam1Lbl3.text = data[2].matches?[0].homeTeam
                        upcomingteam2Lbl3.text = data[2].matches?[0].awayTeam
                        upcomingdateLbl3.text = Date().formatDate(outputFormat: dateFormat(rawValue: "yyyy-MM-dd")!) + " | " + (data[2].matches?[0].time ?? "")
                        upcomingPredictBtn3.tag = 2
                        upcomingPredictBtn3.setTitle("Predict".localized, for: .normal)
                        upcomingPredictBtn3.addTarget(self, action: #selector(predictBtn3), for: .touchUpInside)
                    }
                    
                }
            }
        }
        else{
            handleError(data.error)
        }
        
    }
    
    func handleError(_ error :  ErrorResponse?){
        if let error = error {
            if error.messages?.first != "Unauthorized user" {
                self.customAlertView(title: ErrorMessage.alert.localized, description: error.messages?.first ?? CustomErrors.unknown.description, image: ImageConstants.alertImage)
            }
            else{
                self.customAlertView_3Actions(title: "Login / Sign Up".localized, description: ErrorMessage.loginRequires.localized) {
                    /// Show login page to login/register new user
                    self.presentViewController(LoginVC.self, storyboardName: StoryboardName.login) { vc in
                        vc.delegate = self
                        
                    }
                } dismissAction: {
                    self.navigationController?.popViewController(animated: true)
                }
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
        if let data = data.response?.data{
            UIView.animate(withDuration: 1.0) { [self] in
                switch(data.count){
                case 0:
                    placedPredictionsStackView.isHidden = true
                case 1:
                    placedPredictionsStackView.isHidden = false
                    placedPredictionView1.isHidden = false
                    placedPredictionView2.isHidden = true
                    placedPredictionView3.isHidden = true
                case 2:
                    placedPredictionsStackView.isHidden = false
                    placedPredictionView1.isHidden = false
                    placedPredictionView2.isHidden = false
                    placedPredictionView3.isHidden = true
                case 3:
                    placedPredictionsStackView.isHidden = false
                    placedPredictionView1.isHidden = false
                    placedPredictionView2.isHidden = false
                    placedPredictionView3.isHidden = false
                    
                default:
                    break
                }
                
                if data.count > 0{
                    seeAllPlacedPredictionsBtn.addTarget(self, action: #selector(placedPredictionSeeAll), for: .touchUpInside)
                    predictionTopView.predictionHistoryBtn.setTitle("Check Prediction History".localized, for: .normal)
                    predictionTopView.totalCountLbl.text = "\(data[0].user?.predStats?.allCnt ?? 0)"
                    predictionTopView.wonCountLbl.text = "\(data[0].user?.predStats?.successCnt ?? 0)"
                    predictionTopView.lostCountLbl.text = "\(data[0].user?.predStats?.unsuccessCnt ?? 0)"
                    predictionTopView.wonLbl.text = "Won".localized
                    predictionTopView.lostLbl.text = "Lost".localized
                    predictionTopView.totalLbl.text = "Total".localized
                    predictionsLeagueNameLbl1.text = data[0].matchDetail.leagueName
                    predictionsTeam1ImgView1.sd_imageIndicator = SDWebImageActivityIndicator.white
                    predictionsTeam1ImgView1.sd_setImage(with: URL(string: data[0].matchDetail.homeTeamImage ?? ""))
                    predictionsTeam2ImgView1.sd_imageIndicator = SDWebImageActivityIndicator.white
                    predictionsTeam2ImgView1.sd_setImage(with: URL(string: data[0].matchDetail.awayTeamImage ?? ""))
                    predictionsTeam1Lbl1.text = data[0].matchDetail.homeTeamName?.localized
                    predictionsTeam2Lbl1.text = data[0].matchDetail.awayTeamName?.localized
                    predictionsdateLbl1.text =  data[0].matchDetail.matchDatetime
                    if let index = (data[0].createdAt?.range(of: "T")?.lowerBound)
                    {
                        let beforeT = String(data[0].createdAt?.prefix(upTo: index) ?? "")
                        predictionsTimeLbl1.text = beforeT
                    }
                    
                    predictionsTeamWinLbl1.text = "Prediction: ".localized + getPredictedTeam(predictiveTeam: data[0].predictedTeam).localized
                    // seeAllBtn.addTarget(self, action: #selector(placedPredictionSeeAll), for: .touchUpInside)
                }
                if data.count > 1{
                    
                    predictionsLeagueLbl2.text = data[1].matchDetail.leagueName
                    predictionsTeam1ImgView2.sd_imageIndicator = SDWebImageActivityIndicator.white
                    predictionsTeam1ImgView2.sd_setImage(with: URL(string: data[1].matchDetail.homeTeamImage ?? ""))
                    predictionsTeam2ImgView2.sd_imageIndicator = SDWebImageActivityIndicator.white
                    predictionsTeam2ImgView2.sd_setImage(with: URL(string: data[1].matchDetail.awayTeamImage ?? ""))
                    predictionTeam1Lbl2.text = data[1].matchDetail.homeTeamName?.localized
                    predictionsTeam2Lbl2.text = data[1].matchDetail.awayTeamName?.localized
                    predictionsdateLbl2.text =  data[1].matchDetail.matchDatetime
                    if let index = (data[1].createdAt?.range(of: "T")?.lowerBound)
                    {
                        let beforeT = String(data[1].createdAt?.prefix(upTo: index) ?? "")
                        predictionsTimeLbl2.text = beforeT
                    }
                   
                    predictionsTeamWinLbl2.text = "Prediction: ".localized + getPredictedTeam(predictiveTeam: data[1].predictedTeam).localized
                    
                }
                if data.count > 2{
                    
                    predictionsLeagueNameLbl3.text = data[2].matchDetail.leagueName
                    predictionsTeam1ImgView3.sd_imageIndicator = SDWebImageActivityIndicator.white
                    predictionsTeam1ImgView3.sd_setImage(with: URL(string: data[2].matchDetail.homeTeamImage ?? ""))
                    predictionsTeam2ImgView3.sd_imageIndicator = SDWebImageActivityIndicator.white
                    predictionsTeam2ImgView3.sd_setImage(with: URL(string: data[2].matchDetail.awayTeamImage ?? ""))
                    predictionsTeam1Lbl3.text = data[2].matchDetail.homeTeamName
                    predictionsTeam2Lbl3.text = data[2].matchDetail.awayTeamName
                    predictionsdateLbl3.text =  data[2].matchDetail.matchDatetime
                    if let index = (data[2].createdAt?.range(of: "T")?.lowerBound)
                    {
                        let beforeT = String(data[2].createdAt?.prefix(upTo: index) ?? "")
                        predictionsTimeLbl3.text = beforeT
                    }
                    predictionsTeamWinLbl3.text = "Prediction: ".localized + getPredictedTeam(predictiveTeam: data[2].predictedTeam).localized
                    
                }
                
            }
        }
        
        else{
            handleError(data.error)
        }
    }
    
}

extension HomePredictionViewController {
    func addNavigationBar(title:String){
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = #colorLiteral(red: 0.7333333333, green: 0.09803921569, blue: 0.06274509804, alpha: 1)
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = title
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        let yourBackImage = UIImage(named: "cardGame_back")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.backItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .white
        
    }
    
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
    
    func getPredictedTeam(predictiveTeam:String?) -> String{
        if predictiveTeam == "1"{
            return "Draw"
        }
        else if predictiveTeam == "2"{
            return "Home"
        }
        else if predictiveTeam == "3"{
            return "Away"
        }
        else{
            return ""
        }
    }
}

extension HomePredictionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == predictionTopView.tagsCollectionView{
            return UserDefaults.standard.user?.tags.count ?? 0
        }
        else{
            return sportsArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == predictionTopView.tagsCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.predictTagCollectionViewCell, for: indexPath) as! PredictionTagCollectionViewCell
            cell.tagsLbl.text = UserDefaults.standard.user?.tags[indexPath.row].localized
            cell.tagsLbl.textColor = .random
            cell.tagsLbl.borderColor = cell.tagsLbl.textColor
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.leagueNamesCollectionCell, for: indexPath) as! LeagueCollectionViewCell
            cell.leagueName.text = sportsArr[indexPath.row].localized
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == predictionTopView.tagsCollectionView{
            
        }
        else{
            fetchPredictionMatchesViewModel()
            selectedSports = sportsArr[indexPath.row]
            makeNetworkCall(sport: selectedSports)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == predictionTopView.tagsCollectionView{
            return CGSize(width: 100, height: 30)
        }
        else{
            return CGSize(width: screenWidth / 2, height: 15)
        }
    }
    
}

/// LoginVCDelegate to refresh data with login user
extension HomePredictionViewController: LoginVCDelegate {
    func viewControllerDismissed() {
        makeNetworkCall(sport: selectedSports)
        predictionTopView.userImgView.setImage(imageStr: UserDefaults.standard.user?.profileImg ?? "")
        predictionTopView.usernameLbl.text = UserDefaults.standard.user?.name
        predictionTopView.totalCountLbl.text = "\(predictionListUserModel?.response?.data?[0].user?.predStats?.allCnt ?? 0)"
        predictionTopView.wonCountLbl.text = "\(predictionListUserModel?.response?.data?[0].user?.predStats?.successCnt ?? 0)"
        predictionTopView.lostCountLbl.text = "\(predictionListUserModel?.response?.data?[0].user?.predStats?.unsuccessCnt ?? 0)"
        if ((UserDefaults.standard.token ?? "") != "") && ((UserDefaults.standard.user?.otpVerified ?? 0) == 1) {
            removeBlurView()
            predictionTopView.tagsCollectionView.register(CellIdentifier.predictTagCollectionViewCell)
            predictionTopView.tagsCollectionView.delegate = self
            predictionTopView.tagsCollectionView.dataSource = self
            predictionTopView.tagsCollectionView.reloadData()
            predictionTopView.predictionHistoryBtn.addTarget(self, action: #selector(placedPredictionSeeAll), for: .touchUpInside)
            
        }
        
    }
}
