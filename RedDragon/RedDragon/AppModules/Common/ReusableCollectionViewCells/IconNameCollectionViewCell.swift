//
//  IconNameCollectionViewCell.swift
//  RedDragon
//
//  Created by Qasr01 on 27/10/2023.
//

import UIKit

enum IconNameCellStyle {
    case league
    case team
    case services
}

class IconNameCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var iconImageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(title: String, iconName: String = "", style: IconNameCellStyle) {
        /// 3 IconNameCellStyle added
        /// cell view's border, icon size, title font depends on "style", check and change accordingly
        
        bgView.borderWidth = style == .services ? 0 : 1
        
        titleLabel.text = title
        titleLabel.font = fontMedium(style == .services ? 13 : 11)
        iconImageWidthConstraint.constant = style == .team ? (0.7 * 60) : 60
        
        iconImageView.cornerRadius = iconImageWidthConstraint.constant / 2
        print(iconImageView.cornerRadius)
        iconImageView.clipsToBounds = true
        
        //Check image or url, placeholder image
        iconImageView.setImage(imageStr: iconName, placeholder: (style == .league ? .noLeague : (style == .team ? .noTeam : nil)))
    }
}
