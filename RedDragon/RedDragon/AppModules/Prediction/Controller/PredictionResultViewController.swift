//
//  PredictionResultViewController.swift
//  RedDragon
//
//  Created by Ali on 11/21/23.
//

import UIKit
import SDWebImage

class PredictionResultViewController: UIViewController {

    @IBOutlet weak var predictionsCommentsView: PredictionDetailCommentsView!
    @IBOutlet weak var predictionDetailTitleLbl: UILabel!
    @IBOutlet weak var predictionDescriptionView: PredictResultDescriptionView!
    @IBOutlet weak var predictionResultView: PredictResultTopView!
    
    var analysisData: AnalysisData?
    var data: MatchDataClass?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        predictionDetailTitleLbl.text = "Prediction Details".localized
        configureTopView()
        configureDescriptionView()
    }
    
    func configureTopView(){
        self.predictionResultView.selectedMatchLbl.text = "Selected Match".localized
        self.predictionResultView.leagueImgView.sd_imageIndicator = SDWebImageActivityIndicator.white
        self.predictionResultView.leagueImgView.sd_setImage(with: URL(string: data?.homeEvents.first?.leagueLogo ?? ""))
        self.predictionResultView.leagueNameLbl.text = data?.leagueName
        self.predictionResultView.team1Lbl.text = data?.homeTeamName
        self.predictionResultView.team2Lbl.text = data?.awayTeamName
        self.predictionResultView.dateLbl.text = data?.matchDatetime
        self.predictionResultView.team1NameLbl.text = data?.homeTeamName
        self.predictionResultView.team2NameLbl.text = data?.awayTeamName
        self.predictionResultView.drawLbl.text = "Draw".localized
        self.predictionDescriptionView.descriptionTxtView.text = self.analysisData?.comments
        
       
            if analysisData?.isSuccess == 0{
                self.predictionResultView.predictionLbl.text = "Wrong Prediction".localized
                self.predictionResultView.predictionLbl.textColor = UIColor.init(hex: "BB1910")
                if analysisData?.predictedTeam == "1"{
                    self.predictionResultView.drawView.borderColor = UIColor.init(hex: "BA1A1A")
                    self.predictionResultView.drawView.borderWidth = 2
                    self.predictionResultView.drawView.backgroundColor = UIColor.init(hex: "FFDAD6")
                    self.predictionResultView.drawSelectionImgView.isHidden = false
                    self.predictionResultView.drawSelectionImgView.image = UIImage(named: "wrong")
                    self.predictionResultView.team1SelectionImgView.isHidden = true
                    self.predictionResultView.team2SelectionImgView.isHidden = true
                    if analysisData?.winnerTeam == "2"{
                        self.predictionResultView.team1View.borderColor = UIColor.init(hex: "308C57")
                        self.predictionResultView.team1View.borderWidth = 2
                        self.predictionResultView.team1View.backgroundColor = UIColor.init(hex: "CEF6D7")
                        self.predictionResultView.team1SelectionImgView.isHidden = false
                        self.predictionResultView.team1SelectionImgView.image = UIImage(named: "right")
                       // self.predictionResultView.drawSelectionImgView.isHidden = true
                        self.predictionResultView.team2SelectionImgView.isHidden = true
                    }
                    else if analysisData?.winnerTeam == "3"{
                        self.predictionResultView.team2View.borderColor = UIColor.init(hex: "308C57")
                        self.predictionResultView.team2View.borderWidth = 2
                        self.predictionResultView.team2View.backgroundColor = UIColor.init(hex: "CEF6D7")
                        self.predictionResultView.team2SelectionImgView.isHidden = false
                        self.predictionResultView.team2SelectionImgView.image = UIImage(named: "right")
                    //    self.predictionResultView.drawSelectionImgView.isHidden = true
                        self.predictionResultView.team1SelectionImgView.isHidden = true
                    }
                    
                    
                }
                else if analysisData?.predictedTeam == "2"{
                    
                    self.predictionResultView.team1View.borderColor = UIColor.init(hex: "BA1A1A")
                    self.predictionResultView.team1View.borderWidth = 2
                    self.predictionResultView.team1View.backgroundColor = UIColor.init(hex: "FFDAD6")
                    self.predictionResultView.team1SelectionImgView.isHidden = false
                    self.predictionResultView.team1SelectionImgView.image = UIImage(named: "wrong")
                    self.predictionResultView.drawSelectionImgView.isHidden = true
                    self.predictionResultView.team2SelectionImgView.isHidden = true
                    
                    if analysisData?.winnerTeam == "1"{
                        self.predictionResultView.drawView.borderColor = UIColor.init(hex: "308C57")
                        self.predictionResultView.drawView.borderWidth = 2
                        self.predictionResultView.drawView.backgroundColor = UIColor.init(hex: "CEF6D7")
                        self.predictionResultView.drawSelectionImgView.isHidden = false
                        self.predictionResultView.drawSelectionImgView.image = UIImage(named: "right")
                     //   self.predictionResultView.team1SelectionImgView.isHidden = true
                        self.predictionResultView.team2SelectionImgView.isHidden = true
                    }
                    else if analysisData?.winnerTeam == "3"{
                        self.predictionResultView.team2View.borderColor = UIColor.init(hex: "308C57")
                        self.predictionResultView.team2View.borderWidth = 2
                        self.predictionResultView.team2View.backgroundColor = UIColor.init(hex: "CEF6D7")
                        self.predictionResultView.team2SelectionImgView.isHidden = false
                        self.predictionResultView.team2SelectionImgView.image = UIImage(named: "right")
                        self.predictionResultView.drawSelectionImgView.isHidden = true
                   //     self.predictionResultView.team1SelectionImgView.isHidden = true
                        
                    }
                    
                }
                else if analysisData?.predictedTeam == "3"{
                    self.predictionResultView.team2View.borderColor = UIColor.init(hex: "BA1A1A")
                    self.predictionResultView.team2View.borderWidth = 2
                    self.predictionResultView.team2View.backgroundColor = UIColor.init(hex: "FFDAD6")
                    self.predictionResultView.team2SelectionImgView.isHidden = false
                    self.predictionResultView.team2SelectionImgView.image = UIImage(named: "wrong")
                    self.predictionResultView.team1SelectionImgView.isHidden = true
                    self.predictionResultView.drawSelectionImgView.isHidden = true
                    
                    if analysisData?.winnerTeam == "1"{
                        self.predictionResultView.drawView.borderColor = UIColor.init(hex: "308C57")
                        self.predictionResultView.drawView.borderWidth = 2
                        self.predictionResultView.drawView.backgroundColor = UIColor.init(hex: "CEF6D7")
                        self.predictionResultView.drawSelectionImgView.isHidden = false
                        self.predictionResultView.drawSelectionImgView.image = UIImage(named: "right")
                        self.predictionResultView.team1SelectionImgView.isHidden = true
                    //    self.predictionResultView.team2SelectionImgView.isHidden = true
                    }
                    else if analysisData?.winnerTeam == "2"{
                        self.predictionResultView.team1View.borderColor = UIColor.init(hex: "308C57")
                        self.predictionResultView.team1View.borderWidth = 2
                        self.predictionResultView.team1View.backgroundColor = UIColor.init(hex: "CEF6D7")
                        self.predictionResultView.team1SelectionImgView.isHidden = false
                        self.predictionResultView.team1SelectionImgView.image = UIImage(named: "right")
                        self.predictionResultView.drawSelectionImgView.isHidden = true
                      //  self.predictionResultView.team2SelectionImgView.isHidden = true
                    }
                }
                
            }
            else if analysisData?.isSuccess == 1{
                self.predictionResultView.predictionLbl.text = "Correct Prediction".localized
                self.predictionResultView.predictionLbl.textColor = UIColor.init(hex: "308C57")
                if analysisData?.predictedTeam == "1"{
                    self.predictionResultView.drawView.borderColor = UIColor.init(hex: "308C57")
                    self.predictionResultView.drawView.borderWidth = 2
                    self.predictionResultView.drawView.backgroundColor = UIColor.init(hex: "CEF6D7")
                    self.predictionResultView.drawSelectionImgView.isHidden = false
                    self.predictionResultView.drawSelectionImgView.image = UIImage(named: "right")
                    self.predictionResultView.team1SelectionImgView.isHidden = true
                    self.predictionResultView.team2SelectionImgView.isHidden = true
                    
                }
                else if analysisData?.predictedTeam == "2"{
                    self.predictionResultView.team1View.borderColor = UIColor.init(hex: "308C57")
                    self.predictionResultView.team1View.borderWidth = 2
                    self.predictionResultView.team1View.backgroundColor = UIColor.init(hex: "CEF6D7")
                    self.predictionResultView.team1SelectionImgView.isHidden = false
                    self.predictionResultView.team1SelectionImgView.image = UIImage(named: "right")
                    self.predictionResultView.drawSelectionImgView.isHidden = true
                    self.predictionResultView.team2SelectionImgView.isHidden = true
                    
                }
                else if analysisData?.predictedTeam == "3"{
                    self.predictionResultView.team2View.borderColor = UIColor.init(hex: "308C57")
                    self.predictionResultView.team2View.borderWidth = 2
                    self.predictionResultView.team2View.backgroundColor = UIColor.init(hex: "CEF6D7")
                    self.predictionResultView.team2SelectionImgView.isHidden = false
                    self.predictionResultView.team2SelectionImgView.image = UIImage(named: "right")
                    self.predictionResultView.drawSelectionImgView.isHidden = true
                    self.predictionResultView.team1SelectionImgView.isHidden = true
                }
            }
            
    }
    
    func configureDescriptionView(){
        predictionDescriptionView.descriptionLbl.text = "Description".localized
    }
    
    func configureCommentsView(){
        predictionsCommentsView.commentsLbl.text = "Comments".localized
        predictionsCommentsView.viewAllBtn.setTitle("View all".localized, for: .normal)
        
    }


    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
