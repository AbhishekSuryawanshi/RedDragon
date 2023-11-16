//
//  RecentMatchTableViewCell.swift
//  RedDragon
//
//  Created by QASR02 on 15/11/2023.
//

import UIKit
import SDWebImage

class RecentMatchTableViewCell: UITableViewCell {

    @IBOutlet weak var leagueImageView: UIImageView!
    @IBOutlet weak var leagueNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var homeAwayTeamScoreLabel: UILabel!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureRecentMatches(data: Event, indexPath: IndexPath) {
        leagueImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        leagueImageView.sd_setImage(with: URL(string: data.leagueLogo))
        leagueNameLabel.text = data.leagueName
        configureEvent(event: data.matches[indexPath.item])
    }
    
    func configureEvent(event: Match) {
        dateLabel.text = event.date
        homeTeamNameLabel.text = event.homeName
        awayTeamNameLabel.text = event.awayName
        homeAwayTeamScoreLabel.text = "\(event.homeScore) \(event.awayScore)"
    }
    
}
