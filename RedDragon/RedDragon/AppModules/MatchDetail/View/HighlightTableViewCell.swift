//
//  HighlightTableViewCell.swift
//  RedDragon
//
//  Created by QASR02 on 08/11/2023.
//

import UIKit

class HighlightTableViewCell: UITableViewCell {
    
    @IBOutlet weak var homeTeamView: UIView!
    @IBOutlet weak var awayTeamView: UIView!
    @IBOutlet weak var symbolImageView: UIImageView!
    @IBOutlet weak var homeTeamTimeLabel: UILabel!
    @IBOutlet weak var homeTeam_mainPlayerNameLabel: UILabel!
    @IBOutlet weak var homeTeam_subPlayerLabel: UILabel!
    @IBOutlet weak var homeTeam_subPlayerNameLabel: UILabel!
    @IBOutlet weak var awayTeamTimeLabel: UILabel!
    @IBOutlet weak var awayTeam_mainPlayerNameLabel: UILabel!
    @IBOutlet weak var awayTeam_subPlayerLabel: UILabel!
    @IBOutlet weak var awayTeam_subPlayerNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
