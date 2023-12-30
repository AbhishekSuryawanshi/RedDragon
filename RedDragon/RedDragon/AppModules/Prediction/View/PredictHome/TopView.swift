//
//  TopView.swift
//  RedDragon
//
//  Created by Ali on 11/21/23.
//

import UIKit

class TopView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var walletPointsLbl: UILabel!
    @IBOutlet weak var predictionHistoryBtn: UIButton!
    @IBOutlet weak var totalCountLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var lostCountLbl: UILabel!
    @IBOutlet weak var lostLbl: UILabel!
    @IBOutlet weak var wonCountLbl: UILabel!
    @IBOutlet weak var wonLbl: UILabel!
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var userImgView: UIImageView!
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           commonInit()
       }
       
       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           commonInit()
       }
       
       func commonInit() {
           Bundle.main.loadNibNamed("TopView", owner: self, options: nil)
           contentView.fixInView(self)
       }
    
}
