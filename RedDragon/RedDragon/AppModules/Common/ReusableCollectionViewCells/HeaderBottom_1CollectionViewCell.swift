//
//  HeaderBottom_1CollectionViewCell.swift
//  RedDragon
//
//  Created by Qasr01 on 26/10/2023.
//

import UIKit

class HeaderBottom_1CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setCellValues(title: String, iconName: String = "", selected: Bool) {
        titleLabel.textColor = selected ? .white : .base
        iconImageView.tintColor = selected ? .white : .base
        bgView.backgroundColor = selected ? .base : .white
        titleLabel.text = title
    }
}
