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
        
    }
    
    func configureTopView(){
        if selectedUpComingMatch != nil{
            predictionDetailTopView.leagueNameLbl.text = selectedUpComingMatch?.league
            predictionDetailTopView.leagueImgView.sd_imageIndicator = SDWebImageActivityIndicator.white
            predictionDetailTopView.leagueImgView.sd_setImage(with: URL(string: selectedUpComingMatch?.logo ?? ""))
            predictionDetailTopView.team1Lbl.text = selectedUpComingMatch?.matches?[selectedUpComingPosition].homeTeam
            predictionDetailTopView.team2Lbl.text = selectedUpComingMatch?.matches?[selectedUpComingPosition].awayTeam
            predictionDetailTopView.dateLbl.text = Date().formatDate(outputFormat: dateFormat(rawValue: "yyyy-MM-dd")!) + " | " + (selectedUpComingMatch?.matches?[selectedUpComingPosition].time)!
        }
        else{
            predictionDetailTopView.leagueNameLbl.text = selectedMatch?.league
            predictionDetailTopView.leagueImgView.sd_imageIndicator = SDWebImageActivityIndicator.white
            predictionDetailTopView.leagueImgView.sd_setImage(with: URL(string: selectedMatch?.logo ?? ""))
            predictionDetailTopView.team1Lbl.text = selectedMatch?.matches?[0].homeTeam
            predictionDetailTopView.team2Lbl.text = selectedMatch?.matches?[0].awayTeam
            predictionDetailTopView.dateLbl.text = Date().formatDate(outputFormat: dateFormat(rawValue: "yyyy-MM-dd")!) + " | " + (selectedMatch?.matches?[0].time)!
        }
        
    }
    
    func configurePlacePredictionView(){
        
        predictionPlaceView.homeBtn.titleLabel?.text = "Home"
        predictionPlaceView.drawBtn.titleLabel?.text = "Draw"
        predictionPlaceView.awayBtn.titleLabel?.text = "Away"
        predictionPlaceView.homeBtn.addTarget(self, action: #selector(homeBtnAction), for: .touchUpInside)
        predictionPlaceView.drawBtn.addTarget(self, action: #selector(drawBtnAction), for: .touchUpInside)
        predictionPlaceView.awayBtn.addTarget(self, action: #selector(awayBtnAction), for: .touchUpInside)
    }
    
    func configurePlacePredictionDescriptionView(){
        placePredictionDescriptionView.descriptionTxtView.delegate = self
        placePredictionDescriptionView.publishPredictionBtn.addTarget(self, action: #selector(publishPredictionBtnAction), for: .touchUpInside)
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
                customAlertView(title: "Alert", description: "Please write description", image: "")
            }
            else{
                fetchMakePredictionViewModel()
                makeNetworkCall()
            }
        }
        else{
            customAlertView(title: "Alert", description: "Please Select a team", image: "")
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
        
        predictionDetailTopView.homeLbl.text = "Home"
        predictionDetailTopView.homePercentValueLbl.text = "\(winstats?.homeTeamPrcnt ?? 0)" + "%"
        predictionDetailTopView.drawLbl.text = "Draw"
        predictionDetailTopView.drawPercentValueLbl.text = "\(winstats?.drawPrcnt ?? 0)" + "%"
        predictionDetailTopView.awayLbl.text = "Away"
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
        value ? Loader.activityIndicator.startAnimating() : Loader.activityIndicator.stopAnimating()
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
            if makePredictionsModel?.message == "success"{
                let okAction = PMAlertAction(title: "OK", style: .default) {
                    
                    self.navigationController?.popViewController(animated: true)
                }
                
                customAlertView(title: makePredictionsModel?.message ?? "", description: "Placed Prediction Successfully", image: "", actions: [okAction]
                                
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
        predictionDetailModelData = data.data?[0]
        UIView.animate(withDuration: 1.0) { [self] in
            DispatchQueue.main.async{
                self.setupProgressView(winstats: self.predictionDetailModelData?.predPercnt?.winStats)
            }
                
        }
        
    }
}

