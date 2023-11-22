//
//  PlaceBetVc.swift
//  RedDragon
//
//  Created by Qoo on 20/11/2023.
//

import UIKit
import Combine

class PlaceBetVc: UIViewController {
    
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
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setValues()
        clicks()
        onPlaceBet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addActivityIndicator()
    }
    

    func setValues(){
        
        guard let match = betItem else{
            return
        }
        
        titleLable.text = UserDefaults.standard.sport ?? Sports.football.title
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
            self.view.makeToast(ErrorMessage.amountEmptyAlert, duration: 3.0, position: .bottom)
        } else if self.oddIndex == "-"{
            self.view.makeToast(ErrorMessage.oddsEmptyAlert, duration: 3.0, position: .bottom)
        }else{
            
            // network call
            viewModel.placeBet(oddIndex: oddIndex, betAmount: etAmount.text ?? "0.0", slug: betItem?.slug ?? "N/A")
        }
    }
    
    
    //handle clicks
    
    func clicks(){
        bgViewOne.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectFirstOdd)))
        bgViewTwo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectSecondOdd)))
        bgViewThree.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectThirdOdd)))
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
        self.customAlertView(title: ErrorMessage.success.localized, description: response.message ??  "", image: ImageConstants.successImage)
    }
    
    func showLoader(_ value: Bool) {
        value ? Loader.activityIndicator.startAnimating() : Loader.activityIndicator.stopAnimating()
    }
    
    func addActivityIndicator() {
        self.view.addSubview(Loader.activityIndicator)
    }
    
}
