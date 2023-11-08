//
//  MatchesHeaderView.swift
//  RedDragon
//
//  Created by Ali on 11/7/23.
//

import UIKit

class MatchesHeaderView: UIView {

    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var headerImgView: UIImageView!
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
           Bundle.main.loadNibNamed("MatchesHeaderView", owner: self, options: nil)
           contentView.fixInView(self)
       }
    

}
