//
//  GlobalMatchesTableViewCell.swift
//  RedDragon
//
//  Created by iOS Dev on 08/12/2023.
//

import UIKit

class GlobalMatchesTableViewCell: UITableViewCell {
    @IBOutlet weak var leagueImageView: UIImageView!
    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var awayImageView: UIImageView!
    @IBOutlet weak var leagueNameLabel: UILabel!
    @IBOutlet weak var dateNameLabel: UILabel!
    @IBOutlet weak var homeNameLabel: UILabel!
    @IBOutlet weak var awayNameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var cornerLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var halftimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
