//
//  ExpertUserListTableViewCell.swift
//  RedDragon
//
//  Created by iOS Dev on 14/12/2023.
//

import UIKit

class PredictUserListTableViewCell: UITableViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var winRateLabel: UILabel!
    @IBOutlet weak var allCountLabel: UILabel!
    @IBOutlet weak var successCountLabel: UILabel!
    @IBOutlet weak var unsuccessCountLabel: UILabel!
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
