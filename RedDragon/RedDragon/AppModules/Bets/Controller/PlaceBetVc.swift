//
//  PlaceBetVc.swift
//  RedDragon
//
//  Created by Qoo on 20/11/2023.
//

import UIKit
import Combine

class PlaceBetVc: UIViewController {
    
    
    @IBOutlet weak var fixedTotalEstReturns: UILabel!
    @IBOutlet weak var fixedTotalStake: UILabel!
    @IBOutlet weak var fixedAmountStake: UILabel!
    @IBOutlet weak var fixedLblChooseOdds: UILabel!
    @IBOutlet var btnBetTitle: UIButton!
    @IBOutlet var expertsLable: UILabel!
    @IBOutlet var matchDetails: UILabel!
    @IBOutlet var titleLable: UILabel!
    @IBOutlet var bgViewThree: UIView!
    @IBOutlet var bgViewTwo: UIView!
    @IBOutlet var bgViewOne: UIView!
    @IBOutlet var estWinAmount: UILabel!
    @IBOutlet var amountPlaced: UILabel!
    @IBOutlet var etAmount: UITextField!
    @IBOutlet var imgLeague: UIImageView!
    @IBOutlet var oddsLable3: UILabel!
    @IBOutlet var oddsLable2: UILabel!
    @IBOutlet var oddsLable1: UILabel!
    @IBOutlet var awayName: UILabel!
    @IBOutlet var homeName: UILabel!
    @IBOutlet var imgHome: UIImageView!
    @IBOutlet var imgAway: UIImageView!
    @IBOutlet var score: UILabel!
    @IBOutlet var leagueLable: UILabel!
    
    
    var matchesList : MatchesList?
    var betItem : Matches?
    var oddIndex = "-"
    var viewModel = PlaceBetViewModel()
    var cancellable = Set<AnyCancellable>()
    var day = "today"
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setValues()
        clicks()
        onPlaceBet()
        setupLocalisations()
    }
    
    func setupLocalisations(){
        btnBetTitle.setTitle("Place Bet".localized, for: .normal)
        fixedTotalEstReturns.text = "Total Est. Returns".localized
        fixedTotalStake.text = "Total Staked".localized
        fixedAmountStake.text = "Amount To Stake".localized
        fixedLblChooseOdds.text = "Chose your Odds".localized
        expertsLable.text = "Experts".localized
        matchDetails.text = "Match Details".localized
    }

    func setValues(){
        guard let match = betItem else{
            return
        }
        
        if match.betDetail?.betPlaced ?? false {
            btnBetTitle.setTitle(ErrorMessage.betPlacedAlready, for: .normal)
        }
        titleLable.text = UserDefaults.standard.sport?.localized ?? Sports.football.title
        leagueLable.text = matchesList?.league
        imgLeague.setImage(imageStr: matchesList?.logo ?? "", placeholder: UIImage(named: ImageConstants.placeHolderLeague))
        homeName.text = match.homeTeam
        awayName.text = match.awayTeam
        if (match.odds1Value ?? "" == "") {
            oddsLable1.text = "1"
        }else{
            oddsLable1.text = match.odds1Value ?? "1"
        }
        
        if (match.odds2Value ?? "" == ""){
            oddsLable2.text = "1"
        }else{
            oddsLable2.text = match.odds2Value ?? "1"
        }
        
        if (match.odds3Value ?? "" == ""){
            oddsLable3.text = "1"
        }else{
            oddsLable3.text = match.odds3Value ?? "1"
        }
        score.text = "\(match.homeScore ?? "0") : \(match.awayScore ?? "0")"
    }
    
 
   
    
    // place bet
    @IBAction func placeBet(_ sender: Any) {
        
        if self.etAmount.text == ""{
            self.view.makeToast(ErrorMessage.amountEmptyAlert.localized, duration: 3.0, position: .bottom)
        } else if self.oddIndex == "-"{
            self.view.makeToast(ErrorMessage.oddsEmptyAlert.localized, duration: 3.0, position: .bottom)
        }else{
            
            if btnBetTitle.titleLabel?.text == ErrorMessage.betPlacedSuccess || btnBetTitle.titleLabel?.text == ErrorMessage.betPlacedAlready{
                self.view.makeToast(ErrorMessage.betPlacedAlready.localized, duration: 3.0, position: .bottom)

            }else{
                
                // network call
                viewModel.placeBet(oddIndex: oddIndex, betAmount: etAmount.text ?? "0.0", slug: betItem?.slug ?? "N/A", day: day)
            }
        }
    }
    
    
    //handle clicks
    
    func clicks(){
        matchDetails.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToMatchDetails)))
        bgViewOne.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectFirstOdd)))
        bgViewTwo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectSecondOdd)))
        bgViewThree.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectThirdOdd)))
    }
    
    @objc func goToMatchDetails(){
        navigateToViewController(MatchDetailsVC.self, storyboardName: StoryboardName.matchDetail, animationType: .autoReverse(presenting: .zoom)){ vc in
            vc.matchSlug = self.betItem?.slug
            vc.sports = UserDefaults.standard.sport ?? Sports.football.title.lowercased()
        }
    }
    
    @objc func selectFirstOdd(){
        bgViewOne.layer.borderWidth = 1
        bgViewTwo.layer.borderWidth = 0
        bgViewThree.layer.borderWidth = 0
        oddIndex = "1"
    }
    
    @objc func selectSecondOdd(){
        bgViewOne.layer.borderWidth = 0
        bgViewTwo.layer.borderWidth = 1
        bgViewThree.layer.borderWidth = 0
        oddIndex = "2"
    }
    
    @objc func selectThirdOdd(){
        bgViewOne.layer.borderWidth = 0
        bgViewTwo.layer.borderWidth = 0
        bgViewThree.layer.borderWidth = 1
        oddIndex = "3"
    }
    
}


// handle response

extension PlaceBetVc {
    
    ///fetch view model for points
    func onPlaceBet() {
        viewModel.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        viewModel.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        viewModel.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.execute_onResponseData(response!)
            })
            .store(in: &cancellable)
    }
    
    func execute_onResponseData(_ response: BetSuccessModel) {
        if let response = response.response?.messages?.first {
            
            self.customAlertView(title: ErrorMessage.success.localized, description: response, image: ImageConstants.successImage) {
                self.navigationController?.popViewController(animated: true)
            }
                btnBetTitle.setTitle(ErrorMessage.betPlacedSuccess, for: .normal)
            }else{
                self.view.makeToast(response.error?.messages?.first, duration: 3.0, position: .bottom)
            }
        }
    
    
    func showLoader(_ value: Bool) {
            value ? startLoader() : stopLoader()
        }
    
    func handleError(_ error :  ErrorResponse?){
        if let error = error {
            if error.messages?.first != "Unauthorized user" {
                self.customAlertView(title: ErrorMessage.alert.localized, description: error.messages?.first ?? CustomErrors.unknown.description, image: ImageConstants.alertImage)
            }
            else{
                self.customAlertView_2Actions(title: "Login / Sign Up".localized, description: ErrorMessage.loginRequires.localized) {
                    /// Show login page to login/register new user
                    self.presentViewController(LoginVC.self, storyboardName: StoryboardName.login)
                }
            }
        }
    }
}


