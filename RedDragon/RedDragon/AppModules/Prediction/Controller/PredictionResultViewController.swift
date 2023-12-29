//
//  PredictionResultViewController.swift
//  RedDragon
//
//  Created by Ali on 11/21/23.
//

import UIKit
import SDWebImage

class PredictionResultViewController: UIViewController {

    @IBOutlet weak var predictionDescriptionView: PredictResultDescriptionView!
    @IBOutlet weak var predictionResultView: PredictResultTopView!
    
    var analysisData: AnalysisData?
    var data: MatchDataClass?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureTopView()
    }
    
    func configureTopView(){
        self.predictionResultView.leagueImgView.sd_imageIndicator = SDWebImageActivityIndicator.white
        self.predictionResultView.leagueImgView.sd_setImage(with: URL(string: data?.homeEvents.first?.leagueLogo ?? ""))
        self.predictionResultView.team1Lbl.text = data?.homeTeamName
        self.predictionResultView.team2Lbl.text = data?.awayTeamName
        self.predictionResultView.dateLbl.text = data?.matchDatetime
        self.predictionResultView.team1Btn.setTitle(data?.homeTeamName, for: .normal)
        self.predictionResultView.team2Btn.setTitle(data?.awayTeamName, for: .normal)
        self.predictionResultView.drawBtn.setTitle("Draw", for: .normal)
        self.predictionDescriptionView.descriptionTxtView.text = self.analysisData?.comments
        
        if(analysisData?.loggedIn == true ){
            if analysisData?.isSuccess == 0{
                if analysisData?.predictedTeam == "1"{
                    self.predictionResultView.drawBtn.backgroundColor = UIColor.init(hex: "FFDAD5")
                    self.predictionResultView.drawBtn.borderWidth = 2
                    self.predictionResultView.drawBtn.borderColor = UIColor.init(hex: "BB1910")
                }
                else if analysisData?.predictedTeam == "2"{
                    self.predictionResultView.team1Btn.backgroundColor = UIColor.init(hex: "FFDAD5")
                    self.predictionResultView.team1Btn.borderWidth = 2
                    self.predictionResultView.team1Btn.borderColor = UIColor.init(hex: "BB1910")
                    
                }
                else if analysisData?.predictedTeam == "3"{
                    self.predictionResultView.team2Btn.backgroundColor = UIColor.init(hex: "FFDAD5")
                    self.predictionResultView.team2Btn.borderWidth = 2
                    self.predictionResultView.team2Btn.borderColor = UIColor.init(hex: "BB1910")
                }
            }
            else if analysisData?.isSuccess == 1{
                if analysisData?.predictedTeam == "1"{
                    self.predictionResultView.drawBtn.backgroundColor = UIColor.init(hex: "CEF6D7")
                    self.predictionResultView.drawBtn.borderWidth = 2
                    self.predictionResultView.drawBtn.borderColor = UIColor.init(hex: "308C57")
                }
                else if analysisData?.predictedTeam == "2"{
                    self.predictionResultView.team1Btn.backgroundColor = UIColor.init(hex: "CEF6D7")
                    self.predictionResultView.team1Btn.borderWidth = 2
                    self.predictionResultView.team1Btn.borderColor = UIColor.init(hex: "308C57")
                    
                }
                else if analysisData?.predictedTeam == "3"{
                    self.predictionResultView.team2Btn.backgroundColor = UIColor.init(hex: "CEF6D7")
                    self.predictionResultView.team2Btn.borderWidth = 2
                    self.predictionResultView.team2Btn.borderColor = UIColor.init(hex: "308C57")
                }
            }
            
        }
    }

    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
