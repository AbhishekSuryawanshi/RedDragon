//
//  MatchesTableViewCell.swift
//  RedDragon
//
//  Created by Ali on 11/7/23.
//

import UIKit

class MatchesTableViewCell: UITableViewCell {

    @IBOutlet weak var team2ScoreLbl: UILabel!
    @IBOutlet weak var team1ScoreLbl: UILabel!
    @IBOutlet weak var cellScoreView: UIView!
    @IBOutlet weak var team2ImgView: UIImageView!
    @IBOutlet weak var team2Lbl: UILabel!
    @IBOutlet weak var team1TeamLbl: UILabel!
    @IBOutlet weak var team1ImgView: UIImageView!
    @IBOutlet weak var cellTeamsView: UIView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var roundLbl: UILabel!
    @IBOutlet weak var cellTopView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
