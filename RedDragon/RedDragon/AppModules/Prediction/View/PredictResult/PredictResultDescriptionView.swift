//
//  PredictionResultDescription.swift
//  RedDragon
//
//  Created by Ali on 11/21/23.
//

import UIKit

class PredictResultDescriptionView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var descriptionTxtView: UITextView!
    @IBOutlet weak var descriptionLbl: UILabel!
   
    override init(frame: CGRect) {
           super.init(frame: frame)
           commonInit()
       }
       
       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           commonInit()
       }
       
       func commonInit() {
           Bundle.main.loadNibNamed("PredictResultDescriptionView", owner: self, options: nil)
           contentView.fixInView(self)
       }
   

}
