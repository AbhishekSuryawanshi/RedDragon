//
//  PredictUpcomingTableViewCell.swift
//  RedDragon
//
//  Created by Ali on 11/22/23.
//

import UIKit

class PredictUpcomingTableViewCell: UITableViewCell {

    @IBOutlet weak var predictBtn: UIButton!
    @IBOutlet weak var team2Lbl: UILabel!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var team1Lbl: UILabel!
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
