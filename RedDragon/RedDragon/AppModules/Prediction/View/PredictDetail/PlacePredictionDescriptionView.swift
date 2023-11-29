//
//  PlacePredictionDescription.swift
//  RedDragon
//
//  Created by Ali on 11/21/23.
//

import UIKit

class PlacePredictionDescriptionView: UIView {

    @IBOutlet weak var publishPredictionBtn: UIButton!
    @IBOutlet weak var descriptionTxtView: UITextView!
    @IBOutlet weak var descriptionLbl: UILabel!
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
           Bundle.main.loadNibNamed("PlacePredictionDescriptionView", owner: self, options: nil)
           contentView.fixInView(self)
       }

}
