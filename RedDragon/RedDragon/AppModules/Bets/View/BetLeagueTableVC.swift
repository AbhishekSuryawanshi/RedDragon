//
//  BetLeagueTableVC.swift
//  RedDragon
//
//  Created by Qoo on 28/11/2023.
//

import UIKit

class BetLeagueTableVC: UITableViewCell {
    
    
    @IBOutlet var statusLable: UILabel!
    @IBOutlet var matchesCount: UILabel!
    @IBOutlet var leagueTitle: UILabel!
    @IBOutlet var leagueLogo: UIImageView!
    @IBOutlet var sectionLable: UILabel!
    @IBOutlet weak var fixedMatches: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configurCell(match: MatchesList, isLive : Bool){
        
        leagueTitle.text = match.league
        leagueLogo.setImage(imageStr: match.logo ?? "", placeholder: UIImage(named: ImageConstants.placeHolderTeam))
        sectionLable.text = match.section
        matchesCount.text = "\(match.matches?.count ?? 0)"
        fixedMatches.text = "Matches".localized
    }
    
}
