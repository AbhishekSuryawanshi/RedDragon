//
//  HeaderTopCollectionViewCell.swift
//  RedDragon
//
//  Created by Qasr01 on 26/10/2023.
//

import UIKit

class HeaderTopCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(title: String, selected: Bool) {
        let formatedText = NSMutableAttributedString()
        titleLabel.attributedText = formatedText.underLineText(title, remove: selected)
        titleLabel.font = selected ? fontBold(17) : fontRegular(17)
    }
}
