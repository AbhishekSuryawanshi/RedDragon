//
//  PredictUpcomingHeaderView.swift
//  RedDragon
//
//  Created by Ali on 11/24/23.
//

import UIKit

class PredictUpcomingHeaderView: UIView {

    @IBOutlet weak var leagueNameLbl: UILabel!
    @IBOutlet weak var leagueImgView: UIImageView!
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
           Bundle.main.loadNibNamed("PredictUpcomingHeaderView", owner: self, options: nil)
           contentView.fixInView(self)
       }

}
