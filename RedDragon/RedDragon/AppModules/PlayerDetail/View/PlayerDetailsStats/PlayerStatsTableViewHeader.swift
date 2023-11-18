//
//  PlayerStatsTableViewHeader.swift
//  RedDragon
//
//  Created by Ali on 11/16/23.
//

import UIKit

class PlayerStatsTableViewHeader: UIView {

    @IBOutlet weak var headerLbl: UILabel!
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
           Bundle.main.loadNibNamed("PlayerStatsTableViewHeader", owner: self, options: nil)
           contentView.fixInView(self)
       }
    

}
