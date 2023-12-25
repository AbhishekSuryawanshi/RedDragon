//
//  PlayerProfileTopView.swift
//  RedDragon
//
//  Created by Ali on 11/1/23.
//

import UIKit

class PlayerProfileTopView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var valueLbl: UILabel!
    @IBOutlet weak var positionLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           commonInit()
       }
       
       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           commonInit()
       }
       
       func commonInit() {
           Bundle.main.loadNibNamed("PlayerProfileTopView", owner: self, options: nil)
           contentView.fixInView(self)
       }
   
}


