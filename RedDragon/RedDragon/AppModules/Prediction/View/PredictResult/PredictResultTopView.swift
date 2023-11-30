//
//  PredictResultTopView.swift
//  RedDragon
//
//  Created by Ali on 11/21/23.
//

import UIKit

class PredictResultTopView: UIView {

    @IBOutlet weak var team2Btn: UIButton!
    @IBOutlet weak var drawBtn: UIButton!
    @IBOutlet weak var team1Btn: UIButton!
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
