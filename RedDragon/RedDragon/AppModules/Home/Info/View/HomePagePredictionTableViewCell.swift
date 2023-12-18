//
//  HomePagePredictionTableViewCell.swift
//  RedDragon
//
//  Created by QASR02 on 18/12/2023.
//

import UIKit

class HomePagePredictionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var homeTeamLabel: UILabel!
    @IBOutlet weak var awayTeamLabel: UILabel!
    @IBOutlet weak var unlockLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var homeTeamPercentLabel: UILabel!
    @IBOutlet weak var awayTeamPercentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(data: HomePagePredictionMatch) {
        homeTeamLabel.text = data.homeTeam
        awayTeamLabel.text = data.awayTeam
        timeLabel.text = data.time
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let formattedDate = dateFormatter.string(from: currentDate)
        dateLabel.text = formattedDate
    }
    
}
