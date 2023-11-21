//
//  MatchTableViewCell.swift
//  RedDragon
//
//  Created by Qasr01 on 30/10/2023.
//

import UIKit

class MatchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var leagueImageView: UIImageView!
    @IBOutlet weak var leagueLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var awayImageView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var homeNameLabel: UILabel!
    @IBOutlet weak var awayNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCellValues(model: SocialMatch) {
        leagueLabel.text = model.league.name
        leagueImageView.setImage(imageStr: model.league.logo, placeholder: .placeholderLeague)
        dateLabel.text = model.matchUnixTime.formatDate(outputFormat: dateFormat.hhmmaddMMMyyyy2, today: true)
        homeImageView.setImage(imageStr: model.homeTeam.logo, placeholder: .placeholderTeam)
        awayImageView.setImage(imageStr: model.awayTeam.logo, placeholder: .placeholderTeam)
        homeNameLabel.text = UserDefaults.standard.language == "en" ? model.homeTeam.enName : model.homeTeam.cnName
        awayNameLabel.text = UserDefaults.standard.language == "en" ? model.awayTeam.enName : model.awayTeam.cnName
        scoreLabel.text = "\(model.homeScores.first ?? 0) - \(model.awayScores.first ?? 0)"
    }
}
