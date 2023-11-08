//
//  PlayerDetailsTopView.swift
//  RedDragon
//
//  Created by Ali on 11/8/23.
//

import UIKit

class PlayerDetailsTopView: UIView {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var mediaDetailTxtView: UITextView!
    @IBOutlet weak var mediaImg: UIImageView!
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           commonInit()
       }
       
       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           commonInit()
       }
       
       func commonInit() {
           Bundle.main.loadNibNamed("PlayerDetailsTopView", owner: self, options: nil)
           contentView.fixInView(self)
       }
    
}
