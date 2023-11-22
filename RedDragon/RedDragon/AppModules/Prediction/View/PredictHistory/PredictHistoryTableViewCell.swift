//
//  PredictHistoryTableViewCell.swift
//  RedDragon
//
//  Created by Ali on 11/22/23.
//

import UIKit

class PredictHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var correctPredictionLbl: UILabel!
    @IBOutlet weak var wrongPredictionLbl: UILabel!
    @IBOutlet weak var rewardsLbl: UILabel!
    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var team2Lbl: UILabel!
    @IBOutlet weak var team2ImgView: UIImageView!
    @IBOutlet weak var team1Lbl: UILabel!
    @IBOutlet weak var team1ImgView: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var leagueNameLbl: UILabel!
    @IBOutlet weak var leagueImgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
