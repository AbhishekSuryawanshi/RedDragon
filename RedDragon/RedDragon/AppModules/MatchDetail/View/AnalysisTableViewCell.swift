//
//  AnalysisTableViewCell.swift
//  RedDragon
//
//  Created by Ali on 11/29/23.
//

import UIKit

class AnalysisTableViewCell: UITableViewCell {

    @IBOutlet weak var predictionLbl: UILabel!
    @IBOutlet weak var predictedLbl: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var winPercentageLbl: UILabel!
    @IBOutlet weak var winRateLbl: UILabel!
  //  @IBOutlet weak var descriptionTxtView: UITextView!
    @IBOutlet weak var fireCountLbl: UILabel!
    @IBOutlet weak var betsLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var userImgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
