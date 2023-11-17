//
//  SubstituteTableViewCell.swift
//  RedDragon
//
//  Created by Abhishek Suryawanshi on 17/11/23.
//

import UIKit
import SDWebImage

class SubstituteTableViewCell: UITableViewCell {

    @IBOutlet weak var homePlayerImageView: UIImageView!
    @IBOutlet weak var homePlayerNameLabel: UILabel!
    @IBOutlet weak var homePlayerNumberLabel: UILabel!
    @IBOutlet weak var awayPlayerImageView: UIImageView!
    @IBOutlet weak var awayPlayerNameLabel: UILabel!
    @IBOutlet weak var awayPlayerNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
//    func configureSubstituteCell(player: Lineup?) {
//        homePlayerImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
//        homePlayerImageView.sd_setImage(with: URL(string: player?.playerSubstitute[2]))
//    }
    
}
