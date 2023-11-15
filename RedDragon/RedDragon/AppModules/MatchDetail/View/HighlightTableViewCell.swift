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
    
    func configureCell(progressData: Progress, indexPath: IndexPath) {
        let data = progressData.data[indexPath.row]
        
        if data.isHome == true {
            homeTeamView.isHidden = false
            awayTeamView.isHidden = true
            homeTeamTimeLabel.text = data.time
            homeTeam_mainPlayerNameLabel.text = data.mainPlayerName
            let components = data.subPlayerName.components(separatedBy: " ")
            if components.count >= 2 {
                homeTeam_subPlayerLabel.text = components[0] //instead, pass
                let secondLabel = components[1...]
                homeTeam_subPlayerNameLabel.text = secondLabel.joined(separator: " ")
            } else {
                homeTeam_subPlayerLabel.text = "-"
                homeTeam_subPlayerNameLabel.text = progressData.data[indexPath.row].subPlayerName
            }
        }
        if progressData.data[indexPath.row].isHome == false {
            homeTeamView.isHidden = true
            awayTeamView.isHidden = false
            awayTeamTimeLabel.text = data.time
            awayTeam_mainPlayerNameLabel.text = data.mainPlayerName
            let components = data.subPlayerName.components(separatedBy: " ")
            if components.count >= 2 {
                awayTeam_subPlayerLabel.text = components[0] //instead, pass
                let secondLabel = components[1...]
                awayTeam_subPlayerNameLabel.text = secondLabel.joined(separator: " ")
            } else {
                awayTeam_subPlayerLabel.text = "-"
                awayTeam_subPlayerNameLabel.text = data.subPlayerName
            }
        }
        let imageName = data.action
        configureSymbolImageView(action: imageName)
    }
    
    func configureSymbolImageView(action: String) {
        switch action {
        case let action where action.contains("yellow"):
            symbolImageView.image = UIImage.yellowCard
        case let action where action.contains("Minutes added 3"):
            symbolImageView.image = UIImage.minutes
        case let action where action.contains("substitute"):
            symbolImageView.image = UIImage.substitution
        case let action where action.contains("goal"):
            symbolImageView.image = UIImage.goal
        default:
            break
        }
    }

}
