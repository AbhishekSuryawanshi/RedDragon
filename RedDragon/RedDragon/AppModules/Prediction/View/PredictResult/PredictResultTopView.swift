//
//  PredictResultTopView.swift
//  RedDragon
//
//  Created by Ali on 11/21/23.
//

import UIKit

class PredictResultTopView: UIView {

   
    @IBOutlet weak var team2View: UIView!
    @IBOutlet weak var drawView: UIView!
    @IBOutlet weak var team1View: UIView!
    @IBOutlet weak var team2SelectionImgView: UIImageView!
    @IBOutlet weak var team2NameLbl: UILabel!
    @IBOutlet weak var drawSelectionImgView: UIImageView!
    @IBOutlet weak var drawLbl: UILabel!
    @IBOutlet weak var team1SelectionImgView: UIImageView!
    @IBOutlet weak var team1NameLbl: UILabel!
    @IBOutlet weak var predictionLbl: UILabel!
  //  @IBOutlet weak var team2Btn: UIButton!
  //  @IBOutlet weak var drawBtn: UIButton!
  //  @IBOutlet weak var team1Btn: UIButton!
    @IBOutlet weak var team2Lbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var team1Lbl: UILabel!
    @IBOutlet weak var leagueNameLbl: UILabel!
    @IBOutlet weak var leagueImgView: UIImageView!
    @IBOutlet weak var selectedMatchLbl: UILabel!
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           commonInit()
       }
       
       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           commonInit()
       }
       
       func commonInit() {
           Bundle.main.loadNibNamed("PredictResultTopView", owner: self, options: nil)
           contentView.fixInView(self)
       }
   

}
