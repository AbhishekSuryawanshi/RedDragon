//
//  TeamsView.swift
//  RedDragon
//
//  Created by Ali on 11/1/23.
//

import UIKit

class TeamsView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var team2RankLbl: UILabel!
    @IBOutlet weak var team2Lbl: UILabel!
    @IBOutlet weak var team2ImgView: UIImageView!
    @IBOutlet weak var team1RankLbl: UILabel!
    @IBOutlet weak var team1Lbl: UILabel!
    @IBOutlet weak var team1ImgView: UIImageView!
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           commonInit()
       }
       
       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           commonInit()
       }
       
       func commonInit() {
           Bundle.main.loadNibNamed("TeamsView", owner: self, options: nil)
           contentView.fixInView(self)
       }
   
}
