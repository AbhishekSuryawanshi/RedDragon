//
//  LastMatchesView.swift
//  RedDragon
//
//  Created by Ali on 11/2/23.
//

import UIKit

class LastMatchesView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var team2Lbl: UILabel!
    @IBOutlet weak var team2ImgView: UIImageView!
    @IBOutlet weak var team1Lbl: UILabel!
    @IBOutlet weak var team1ImgView: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var leagueNameLbl: UILabel!
    @IBOutlet weak var leagueImgView: UIImageView!
    @IBOutlet weak var team2ScoreLbl: UILabel!
    @IBOutlet weak var team1ScoreLbl: UILabel!
    @IBOutlet weak var roundLbl: UILabel!
    @IBOutlet weak var seeAllBtn: UIButton!
    @IBOutlet weak var lastMatchesLbl: UILabel!
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           commonInit()
       }
       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           commonInit()
       }
       func commonInit() {
           Bundle.main.loadNibNamed("LastMatchesView", owner: self, options: nil)
           contentView.fixInView(self)
       }
}
