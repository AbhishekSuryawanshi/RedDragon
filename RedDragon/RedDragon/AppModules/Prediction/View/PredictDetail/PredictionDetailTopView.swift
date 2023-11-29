//
//  PredictionDetailTopView.swift
//  RedDragon
//
//  Created by Ali on 11/21/23.
//

import UIKit

class PredictionDetailTopView: UIView {

    @IBOutlet weak var awayPercentValueLbl: UILabel!
    @IBOutlet weak var awayLbl: UILabel!
    @IBOutlet weak var drawPercentValueLbl: UILabel!
    @IBOutlet weak var drawLbl: UILabel!
    @IBOutlet weak var homePercentValueLbl: UILabel!
    @IBOutlet weak var homeLbl: UILabel!
    @IBOutlet weak var viewForStackView: UIView!
    @IBOutlet weak var progressStackView: UIStackView!
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
           Bundle.main.loadNibNamed("PredictionDetailTopView", owner: self, options: nil)
           contentView.fixInView(self)
       }

}


