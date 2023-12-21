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
    @IBOutlet weak var bgViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var iconImageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(title: String, titleTop: CGFloat = 4, iconName: String = "", iconImage: UIImage = .placeholderPost, bgViewWidth: CGFloat = 60, imageWidth: CGFloat = 60, bgViewCornerRadius: CGFloat = 0, iconCornerRadius: CGFloat = 0, borderWidth: CGFloat = 1, font: UIFont = fontRegular(13.5), placeHolderImage: UIImage = .placeholderPost) {
       
        bgViewWidthConstraint.constant = bgViewWidth
        bgView.borderWidth = borderWidth
        bgView.cornerRadius = bgViewCornerRadius
        
        titleLabel.text = title
        titleLabel.font = font
        titleTopConstraint.constant = titleTop
        
        /// pass this (0.7 * 60) for small image in middle, refer SocialVC - teamsCollectionView
        iconImageWidthConstraint.constant = imageWidth
        
        iconImageView.cornerRadius = iconCornerRadius
        iconImageView.clipsToBounds = true
        
        if iconName == "" {
            iconImageView.image = iconImage
        } else {
            iconImageView.setImage(imageStr: iconName, placeholder: placeHolderImage)
        }
    }
}
