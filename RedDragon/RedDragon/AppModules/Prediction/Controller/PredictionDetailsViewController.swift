//
//  PredictionDetailsViewController.swift
//  RedDragon
//
//  Created by Ali on 11/21/23.
//

import UIKit
import SDWebImage
import Combine

class PredictionDetailsViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var placePredictionDescriptionView: PlacePredictionDescriptionView!
    @IBOutlet weak var predictionPlaceView: PlacePredictionView!
    @IBOutlet weak var predictionDetailTopView: PredictionDetailTopView!
    
    private var makePredictionViewModel: MakePredictionViewModel?
    private var predictionDetailViewModel: PredictionDetailViewModel?
    private var cancellable = Set<AnyCancellable>()
    var makePredictionsModel: PredictionMakeModel?
    var predictionDetailModelData: PredictionMatchDetailModelElementData?
    var selectedUpComingMatch: PredictionData?
    
    var selectedUpComingPosition: Int = 0
    var isSelected = ""
    var sport = ""
    var selectedMatch: PredictionData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureTopView()
        configurePlacePredictionView()
        configurePlacePredictionDescriptionView()
        fetchMatchDetailViewModel()
        makeNetworkCall2()
        
       /* let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = #colorLiteral(red: 0.7333333333, green: 0.09803921569, blue: 0.06274509804, alpha: 1)
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Place Prediction"
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance*/
        
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func configureTopView(){
        predictionDetailTopView.selectedMatchLbl.text = "Selected Match".localized
        predictionDetailTopView.homeLbl.text = "Home".localized
        predictionDetailTopView.drawLbl.text = "Draw".localized
        predictionDetailTopView.awayLbl.text = "Away".localized
        
        if selectedUpComingMatch != nil{
            predictionDetailTopView.leagueNameLbl.text = selectedUpComingMatch?.league?.localized
            predictionDetailTopView.leagueImgView.sd_imageIndicator = SDWebImageActivityIndicator.white
            predictionDetailTopView.leagueImgView.sd_setImage(with: URL(string: selectedUpComingMatch?.logo ?? ""))
            predictionDetailTopView.team1Lbl.text = selectedUpComingMatch?.matches?[selectedUpComingPosition].homeTeam?.localized
            predictionDetailTopView.team2Lbl.text = selectedUpComingMatch?.matches?[selectedUpComingPosition].awayTeam?.localized
            predictionDetailTopView.dateLbl.text = Date().formatDate(outputFormat: dateFormat(rawValue: "yyyy-MM-dd")!) + " | " + (selectedUpComingMatch?.matches?[selectedUpComingPosition].time)!
        }
        else{
            predictionDetailTopView.leagueNameLbl.text = selectedMatch?.league?.localized
            predictionDetailTopView.leagueImgView.sd_imageIndicator = SDWebImageActivityIndicator.white
            predictionDetailTopView.leagueImgView.sd_setImage(with: URL(string: selectedMatch?.logo ?? ""))
            predictionDetailTopView.team1Lbl.text = selectedMatch?.matches?[0].homeTeam?.localized
            predictionDetailTopView.team2Lbl.text = selectedMatch?.matches?[0].awayTeam?.localized
            predictionDetailTopView.dateLbl.text = Date().formatDate(outputFormat: dateFormat(rawValue: "yyyy-MM-dd")!) + " | " + (selectedMatch?.matches?[0].time)!
        }
        
    }
    
    func configurePlacePredictionView(){
        
        predictionPlaceView.homeBtn.setTitle("Home".localized, for: .normal)
        predictionPlaceView.drawBtn.setTitle("Draw".localized, for: .normal)
        predictionPlaceView.awayBtn.setTitle("Away".localized, for: .normal)
        predictionPlaceView.homeBtn.addTarget(self, action: #selector(homeBtnAction), for: .touchUpInside)
        predictionPlaceView.drawBtn.addTarget(self, action: #selector(drawBtnAction), for: .touchUpInside)
        predictionPlaceView.awayBtn.addTarget(self, action: #selector(awayBtnAction), for: .touchUpInside)
        predictionPlaceView.placePredictionLbl.text = "Place Prediction".localized
    }
    
    func configurePlacePredictionDescriptionView(){
        placePredictionDescriptionView.descriptionTxtView.delegate = self
        placePredictionDescriptionView.publishPredictionBtn.addTarget(self, action: #selector(publishPredictionBtnAction), for: .touchUpInside)
        placePredictionDescriptionView.descriptionLbl.text = "Description".localized
        placePredictionDescriptionView.publishPredictionBtn.setTitle("Publish Prediction", for: .normal)
    }
    
    func makeNetworkCall2(){
        if selectedUpComingMatch != nil{
            predictionDetailViewModel?.fetchPredictionMatchesDetailAsyncCall(lang: "en", matchID: selectedUpComingMatch?.matches?[selectedUpComingPosition].slug ?? "", sport: sport)
        }
        else{
            predictionDetailViewModel?.fetchPredictionMatchesDetailAsyncCall(lang: "en", matchID: selectedMatch?.matches?[0].slug ?? "", sport: sport)
        }
    }
    
    func makeNetworkCall(){
        
        if selectedUpComingMatch != nil{
            makePredictionViewModel?.fetchMakePredictionAsyncCall(matchID: selectedUpComingMatch?.matches?[selectedUpComingPosition].slug ?? "", predictionTeam: isSelected, comment: self.placePredictionDescriptionView.descriptionTxtView.text, sportType: sport)
        }
        else{
            makePredictionViewModel?.fetchMakePredictionAsyncCall(matchID: selectedMatch?.matches?[0].slug ?? "", predictionTeam: isSelected, comment: self.placePredictionDescriptionView.descriptionTxtView.text, sportType: sport)
        }
    }
    
    @objc func publishPredictionBtnAction(){
        if isSelected != ""{
            if self.placePredictionDescriptionView.descriptionTxtView.text == ""{
                customAlertView(title: "Alert".localized, description: "Please write description".localized, image: "")
            }
            else{
                fetchMakePredictionViewModel()
                makeNetworkCall()
            }
        }
        else{
            customAlertView(title: "Alert".localized, description: "Please Select a team".localized, image: "")
        }
    }
    
    @objc func homeBtnAction(){
        predictionPlaceView.homeBtn.borderWidth = 2
        predictionPlaceView.homeBtn.borderColor = UIColor.init(hex: "00658C")
        
        predictionPlaceView.drawBtn.borderWidth = 0
        predictionPlaceView.awayBtn.borderWidth = 0
        isSelected = "2"
    }
    @objc func drawBtnAction(){
        predictionPlaceView.drawBtn.borderWidth = 2
        predictionPlaceView.drawBtn.borderColor = UIColor.init(hex: "745B00")
        
        predictionPlaceView.homeBtn.borderWidth = 0
        predictionPlaceView.awayBtn.borderWidth = 0
        isSelected = "1"
        
    }
    @objc func awayBtnAction(){
        predictionPlaceView.awayBtn.borderWidth = 2
        predictionPlaceView.awayBtn.borderColor = UIColor.init(hex: "BB1910")
        
        predictionPlaceView.drawBtn.borderWidth = 0
        predictionPlaceView.homeBtn.borderWidth = 0
        isSelected = "3"
        
    }
    
    func setupProgressView(winstats: WinStatsMatch?){
       // let stackView = UIStackView()
     //   predictionDetailTopView.progressStackView = stackView
        predictionDetailTopView.progressStackView.axis = .horizontal
        predictionDetailTopView.progressStackView.distribution = .fillProportionally
        predictionDetailTopView.progressStackView.spacing = 8 // Adjust spacing as needed
        predictionDetailTopView.progressStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Create three subviews
        let view1 = UIView()
        view1.frame.size = CGSize(width: (predictionDetailTopView.progressStackView.frame.width / 100) * CGFloat(winstats?.homeTeamPrcnt ?? 0), height: predictionDetailTopView.progressStackView.frame.height)
        view1.backgroundColor = UIColor.init(hex: "00658C")
        view1.translatesAutoresizingMaskIntoConstraints = false
              
        let view2 = UIView()
        view2.frame.size = CGSize(width: (predictionDetailTopView.progressStackView.frame.width / 100) * CGFloat(winstats?.drawPrcnt ?? 0), height: predictionDetailTopView.progressStackView.frame.height)
        view2.backgroundColor = UIColor.init(hex: "745B00")
        view2.translatesAutoresizingMaskIntoConstraints = false
              
        let view3 = UIView()
        view3.frame.size = CGSize(width: (predictionDetailTopView.progressStackView.frame.width / 100) * CGFloat(winstats?.awayTeamPrcnt ?? 0), height: predictionDetailTopView.progressStackView.frame.height)
        view3.backgroundColor = UIColor.init(hex: "BB1910")
        view3.translatesAutoresizingMaskIntoConstraints = false
        
        predictionDetailTopView.homeLbl.text = "Home".localized
        predictionDetailTopView.homePercentValueLbl.text = "\(winstats?.homeTeamPrcnt ?? 0)" + "%"
        predictionDetailTopView.drawLbl.text = "Draw".localized
        predictionDetailTopView.drawPercentValueLbl.text = "\(winstats?.drawPrcnt ?? 0)" + "%"
        predictionDetailTopView.awayLbl.text = "Away".localized
        predictionDetailTopView.awayPercentValueLbl.text = "\(winstats?.awayTeamPrcnt ?? 0)" + "%"
              
        // Add subviews to stackView
        predictionDetailTopView.progressStackView.addArrangedSubview(view1)
        predictionDetailTopView.progressStackView.addArrangedSubview(view2)
        predictionDetailTopView.progressStackView.addArrangedSubview(view3)
              
        // Add stackView to the main view
        predictionDetailTopView.viewForStackView.addSubview(predictionDetailTopView.progressStackView)
        // Set up Auto Layout constraints for stackView
        
        NSLayoutConstraint.activate([
            predictionDetailTopView.progressStackView.topAnchor.constraint(equalTo: predictionDetailTopView.viewForStackView.topAnchor),
            predictionDetailTopView.progressStackView.leadingAnchor.constraint(equalTo: predictionDetailTopView.viewForStackView.leadingAnchor),
            predictionDetailTopView.progressStackView.trailingAnchor.constraint(equalTo: predictionDetailTopView.viewForStackView.trailingAnchor),
        ])
    }
    
    func showLoader(_ value: Bool) {
        value ? startLoader() : stopLoader()
    }

}

extension PredictionDetailsViewController {
    ///fetch view Model for match prediction
    func fetchMakePredictionViewModel() {
        makePredictionViewModel = MakePredictionViewModel()
        makePredictionViewModel?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        makePredictionViewModel?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        makePredictionViewModel?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] data in
                self?.renderResponseData(data: data!)
            })
            .store(in: &cancellable)
    }
    
    func renderResponseData(data: PredictionMakeModel) {
        makePredictionsModel = data
       // let data = data.data
        UIView.animate(withDuration: 1.0) { [self] in
            if makePredictionsModel?.response?.data?.message == "success"{
                let okAction = PMAlertAction(title: "OK", style: .default) {
                    
                    self.navigationController?.popViewController(animated: true)
                }
                
                customAlertView(title: makePredictionsModel?.response?.data?.message ?? "", description: "Placed Prediction Successfully".localized, image: "", actions: [okAction]
                                
                )
               
            }
                
        }
        
    }
    
    func fetchMatchDetailViewModel() {
        predictionDetailViewModel = PredictionDetailViewModel()
        predictionDetailViewModel?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        predictionDetailViewModel?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        predictionDetailViewModel?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] data in
                self?.renderResponseData(data: data!)
            })
            .store(in: &cancellable)
    }
    
    func renderResponseData(data: PredictionMatchDetailModel) {
        predictionDetailModelData = data.response?.data?[0]
        UIView.animate(withDuration: 1.0) { [self] in
            DispatchQueue.main.async{
                self.setupProgressView(winstats: self.predictionDetailModelData?.predPercnt?.winStats)
            }
                
        }
        
    }
}

