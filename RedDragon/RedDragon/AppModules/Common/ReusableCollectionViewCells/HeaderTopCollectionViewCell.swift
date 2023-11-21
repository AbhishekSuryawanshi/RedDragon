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
    
   /// To use single underline label cell
    func configureUnderLineCell(title: String, selected: Bool) {
        var formatedText = NSMutableAttributedString()
        formatedText = selected ? formatedText.bold(title, size: 17) : formatedText.regular(title, size: 17)
        ///pass true to "remove" key to remove underline
        formatedText.addUnderLine(textToFind: title, remove: !selected)
        titleLabel.attributedText = formatedText
        titleLabel.textColor = .white
    }
    
    /// To use single label cell
    func configureTagCell(title: String) {
        titleLabel.text = title
        titleLabel.font = fontRegular(13)
        titleLabel.textColor = .black
    }
}
