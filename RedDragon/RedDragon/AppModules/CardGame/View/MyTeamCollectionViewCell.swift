//
//  MyTeamCollectionViewCell.swift
//  RedDragon
//
//  Created by QASR02 on 27/11/2023.
//

import UIKit
import SDWebImage

class MyTeamCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var positionNameLabel: UILabel!
    @IBOutlet weak var sellButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var sellForLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /// for My team cell data
    func configuration(data: MyTeamElement) {
        userProfile.sd_imageIndicator = SDWebImageActivityIndicator.white
        userProfile.sd_setImage(with: URL(string: data.imgURL))
        userNameLabel.text = data.name
        positionNameLabel.text = data.position
        //sellButton.setTitle(StringConstants.sell.localized, for: .normal)
    }
    
    /// for leaderboard cell data
    func confiure(data: Player) {
        userProfile.sd_imageIndicator = SDWebImageActivityIndicator.white
        userProfile.sd_setImage(with: URL(string: data.imgURL), placeholderImage: #imageLiteral(resourceName: "cardGame_defaultUser"))
        userNameLabel.text = data.name
        positionNameLabel.text = data.position
        sellButton.isHidden = true
        sellForLabel.text = "Value"
    }

}
