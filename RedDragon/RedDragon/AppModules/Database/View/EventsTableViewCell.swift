//
//  EventsTableViewCell.swift
//  RedDragon
//
//  Created by QASR02 on 01/11/2023.
//

import UIKit

class EventsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var homeTeamLabel: UILabel!
    @IBOutlet weak var vsLabel: UILabel!
    @IBOutlet weak var awayTeamLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        vsLabel.layer.cornerRadius = 11
        vsLabel.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(_ match: Match) {
        roundLabel.text = match.round
        dateLabel.text = match.date
        homeTeamLabel.text = match.homeName
        awayTeamLabel.text = match.awayName
    }
    
}
