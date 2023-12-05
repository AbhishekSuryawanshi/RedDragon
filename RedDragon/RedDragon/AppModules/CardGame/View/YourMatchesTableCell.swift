//
//  YourMatchesTableCell.swift
//  RedDragon
//
//  Created by QASR02 on 05/12/2023.
//

import UIKit
import SDWebImage

class YourMatchesTableCell: UITableViewCell {
    
    @IBOutlet weak var firstPlayerProfileImage: UIImageView!
    @IBOutlet weak var firstPlayerNameLabel: UILabel!
    @IBOutlet weak var firstPlayerScoreLabel: UILabel!
    @IBOutlet weak var secondPlayerProfileImage: UIImageView!
    @IBOutlet weak var secondPlayerNameLabel: UILabel!
    @IBOutlet weak var secondPlayerScoreLabel: UILabel!
    @IBOutlet weak var loseOrWinLabel: UILabel!
    @IBOutlet weak var loseOrWinView: UIView!
    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        backView.borderWidth = 0.7
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(data: YourMatch) {
        firstPlayerNameLabel.text = data.user.name
        firstPlayerProfileImage.sd_imageIndicator = SDWebImageActivityIndicator.white
        firstPlayerProfileImage.sd_setImage(with: URL(string: data.user.imgURL), placeholderImage: #imageLiteral(resourceName: "cardGame_defaultUser"))
        firstPlayerScoreLabel.text = "\(data.score)"
        if data.result == "LOSE" {
            loseOrWinView.backgroundColor = UIColor(red: 255/255, green: 218/255, blue: 213/255, alpha: 1)
        } else {
            loseOrWinView.backgroundColor = UIColor(red: 206/255, green: 246/255, blue: 215/255, alpha: 1)
        }
        loseOrWinLabel.text = data.result
        
        secondPlayerNameLabel.text = data.opponentUser?.name ?? "Computer"
        secondPlayerProfileImage.sd_imageIndicator = SDWebImageActivityIndicator.white
        secondPlayerProfileImage.sd_setImage(with: URL(string: data.opponentUser?.imgURL ?? ""), placeholderImage: #imageLiteral(resourceName: "cardGame_defaultUser"))
        secondPlayerScoreLabel.text = "\(11 - data.score)"
    }
    
}
