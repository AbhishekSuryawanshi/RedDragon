//
//  PlacePredictionView.swift
//  RedDragon
//
//  Created by Ali on 11/21/23.
//

import UIKit

class PlacePredictionView: UIView {

    @IBOutlet weak var awayBtn: UIButton!
    @IBOutlet weak var drawBtn: UIButton!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var placePredictionLbl: UILabel!
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
           Bundle.main.loadNibNamed("PlacePredictionView", owner: self, options: nil)
           contentView.fixInView(self)
       }


}
