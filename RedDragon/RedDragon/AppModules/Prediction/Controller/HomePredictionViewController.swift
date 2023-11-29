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
    
    var sportsArr = ["FootBall" , "BasketBall", "Cricket", "Tennis", "Esports"]
    var selectedMatch: PredictionData?
    private var predictionMatchesViewModel: PredictionViewModel?
    var predictionsModel: PredictionMatchesModel?
    private var cancellable = Set<AnyCancellable>()
    
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
        loadFunctionality()
        fetchPredictionMatchesViewModel()
        makeNetworkCall()
        
    }
    
    func loadFunctionality() {
        nibInitialization()
    }
    
    func nibInitialization() {
        sportsCollectionView.register(CellIdentifier.leagueNamesCollectionCell)
       
    }
    
    func makeNetworkCall() {
        predictionMatchesViewModel?.fetchPredictionMatchesAsyncCall(lang: "en", date: Date().formatDate(outputFormat: dateFormat.yyyyMMdd), sportType: "football")
    }
    func showLoader(_ value: Bool) {
        value ? Loader.activityIndicator.startAnimating() : Loader.activityIndicator.stopAnimating()
    }
    
    @objc func predictBtn1(){
        navigateToViewController(PredictionDetailsViewController.self, storyboardName: StoryboardName.prediction) { vc in
            self.selectedMatch = self.predictionMatchesViewModel?.responseData?.data?[self.upcomingPredictBtn1.tag]
            vc.selectedMatch = self.selectedMatch
                }
    }
    
    @objc func predictBtn2(){
        navigateToViewController(PredictionDetailsViewController.self, storyboardName: StoryboardName.prediction) { vc in
            self.selectedMatch = self.predictionMatchesViewModel?.responseData?.data?[self.upcomingPredictBtn2.tag]
            vc.selectedMatch = self.selectedMatch
                }
    }
    
    @objc func predictBtn3(){
        navigateToViewController(PredictionDetailsViewController.self, storyboardName: StoryboardName.prediction) { vc in
            self.selectedMatch = self.predictionMatchesViewModel?.responseData?.data?[self.upcomingPredictBtn3.tag]
            vc.selectedMatch = self.selectedMatch
        }
    }
    
    @objc func upcomingSeeAll(){
        navigateToViewController(UpComingMatchesViewController.self, storyboardName: StoryboardName.prediction) { vc in
           
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
    


extension HomePredictionViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sportsArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.leagueNamesCollectionCell, for: indexPath) as! LeagueCollectionViewCell
        cell.leagueName.text = sportsArr[indexPath.row]
        return cell
    }
    
    
}


