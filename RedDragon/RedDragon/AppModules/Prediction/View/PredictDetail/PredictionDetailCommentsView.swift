//
//  PredictionDetailCommentsView.swift
//  RedDragon
//
//  Created by Ali on 11/28/23.
//

import UIKit

class PredictionDetailCommentsView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var commentsLbl: UILabel!
    
    @IBOutlet weak var viewAllBtn: UIButton!
    
    @IBOutlet weak var commentsTxtView: UITextView!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
   
    override init(frame: CGRect) {
           super.init(frame: frame)
           commonInit()
       }
       
       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           commonInit()
       }
       
       func commonInit() {
           Bundle.main.loadNibNamed("PredictionDetailCommentsView", owner: self, options: nil)
           contentView.fixInView(self)
       }

}
