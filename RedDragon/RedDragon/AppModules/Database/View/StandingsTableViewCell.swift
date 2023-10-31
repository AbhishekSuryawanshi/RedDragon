//
//  StandingsTableViewCell.swift
//  RedDragon
//
//  Created by QASR02 on 30/10/2023.
//

import UIKit

class StandingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var loseLabel: UILabel!
    @IBOutlet weak var drawLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configuration(_ value: [String]) {
        numberLabel.text = value[0]
        teamLabel.text = value[3]
        pointsLabel.text = value[4]
        winLabel.text = value[5]
        loseLabel.text = value[7]
        drawLabel.text = value[6]
    }
    
}
