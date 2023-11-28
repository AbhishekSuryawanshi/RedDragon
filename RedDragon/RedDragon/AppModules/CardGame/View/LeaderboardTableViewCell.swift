//
//  LeaderboardTableViewCell.swift
//  RedDragon
//
//  Created by QASR02 on 28/11/2023.
//

import UIKit
import SDWebImage

class LeaderboardTableViewCell: UITableViewCell {

    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var levelNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configuaration(_ data: LeaderboardElement) {
        nameLabel.text = data.name
        pointsLabel.text = "\(StringConstants.score.localized) \(data.score)"
        playerImageView.sd_imageIndicator = SDWebImageActivityIndicator.white
        playerImageView.sd_setImage(with: URL(string: data.imgURL), placeholderImage: #imageLiteral(resourceName: "cardGame_defaultUser"))
    }
    
}
