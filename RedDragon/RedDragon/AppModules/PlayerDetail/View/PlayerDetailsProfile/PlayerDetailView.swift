//
//  PlayerDetailView.swift
//  RedDragon
//
//  Created by Ali on 11/2/23.
//

import UIKit

class PlayerDetailView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var playerDetailTxtView: UITextView!
    @IBOutlet weak var playerDetailLbl: UILabel!
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           commonInit()
       }
       
       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           commonInit()
       }
       
       func commonInit() {
           Bundle.main.loadNibNamed("PlayerDetailView", owner: self, options: nil)
           contentView.fixInView(self)
       }
   
}
