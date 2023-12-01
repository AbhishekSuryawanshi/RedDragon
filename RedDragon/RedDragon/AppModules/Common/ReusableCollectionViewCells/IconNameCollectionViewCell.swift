//
//  IconNameCollectionViewCell.swift
//  RedDragon
//
//  Created by Qasr01 on 27/10/2023.
//

import UIKit

class IconNameCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var iconImageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(title: String, iconName: String = "", iconImage: UIImage = .placeholder1, imageWidth: CGFloat = 60, borderWidth: CGFloat = 1, font: UIFont = fontMedium(11), placeHolderImage: UIImage = .placeholder1) {
        
        bgView.borderWidth = borderWidth
        
        titleLabel.text = title
        titleLabel.font = font
        /// width 60 fixed for bgView
        /// pass this (0.7 * 60) for small image in middle, refer SocialVC - teamsCollectionView
        iconImageWidthConstraint.constant = imageWidth
        
        iconImageView.cornerRadius = iconImageWidthConstraint.constant / 2
        iconImageView.clipsToBounds = true
        
        if iconName == "" {
            iconImageView.image = iconImage
        } else {
            iconImageView.setImage(imageStr: iconName, placeholder: placeHolderImage)
        }
    }
}
