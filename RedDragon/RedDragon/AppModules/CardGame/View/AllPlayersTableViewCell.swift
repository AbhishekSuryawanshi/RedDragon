//
//  AllPlayersTableViewCell.swift
//  RedDragon
//
//  Created by QASR02 on 21/11/2023.
//

import UIKit
import SDWebImage

class AllPlayersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var positionNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    //@IBOutlet weak var buyButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(data: PlayerData) {
        playerImageView.sd_imageIndicator = SDWebImageActivityIndicator.white
        playerImageView.sd_setImage(with: URL(string: data.photo))
        playerNameLabel.text = data.name
        positionNameLabel.text = data.positionName
        //buyButton.setTitle(StringConstants.buy.localized, for: .normal)
    }
    
}
