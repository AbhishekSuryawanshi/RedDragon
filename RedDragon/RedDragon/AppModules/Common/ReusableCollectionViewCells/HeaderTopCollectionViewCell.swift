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
    func configureUnderLineCell(title: String, selected: Bool, textColor: UIColor = .white, fontSize: CGFloat = 17) {
        var formatedText = NSMutableAttributedString()
        formatedText = selected ? formatedText.bold(title, size: fontSize) : formatedText.regular(title, size: fontSize)
        ///pass true to "remove" key to remove underline
        formatedText.addUnderLine(textToFind: title, remove: !selected)
        titleLabel.attributedText = formatedText
        titleLabel.textColor = textColor
    }
    
    /// To use single label cell
    func configureTagCell(title: String, textColor: UIColor = .black, font: UIFont = fontRegular(13)) {
        titleLabel.text = title
        titleLabel.font = font
        titleLabel.textColor = textColor
    }
    
    func configureCell(title: String, selected: Bool, textColor: UIColor = .black, selectionColor: UIColor = .base,fontSize: CGFloat = 17) {
        if selected{
            titleLabel.textColor = selectionColor
        }
        else{
            titleLabel.textColor = textColor
        }
        var formatedText = NSMutableAttributedString()
        formatedText = selected ? formatedText.bold(title, size: fontSize) : formatedText.regular(title, size: fontSize)
        formatedText.addUnderLine(textToFind: title, remove: !selected)
        titleLabel.attributedText = formatedText
        
    }
}
