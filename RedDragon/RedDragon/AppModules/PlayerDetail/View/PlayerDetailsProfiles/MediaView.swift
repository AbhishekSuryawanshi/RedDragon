//
//  MediaView.swift
//  RedDragon
//
//  Created by Ali on 11/3/23.
//

import UIKit

class MediaView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var mediaDetailTxtView: UITextView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var mediaImgView: UIImageView!
    @IBOutlet weak var seeAllBtn: UIButton!
    @IBOutlet weak var mediaLbl: UILabel!
   
    override init(frame: CGRect) {
           super.init(frame: frame)
           commonInit()
       }
       
       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           commonInit()
       }
       
       func commonInit() {
           Bundle.main.loadNibNamed("MediaView", owner: self, options: nil)
           contentView.fixInView(self)
       }

}
