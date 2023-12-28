//
//  NameRightIconTableViewCell.swift
//  RedDragon
//
//  Created by Qasr01 on 28/12/2023.
//

import UIKit

class NameRightIconTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureLanguageCell(type: LanguageType, selected: Bool) {
        titleLabel.text = type.rawValue.localized
        rightImageView.image = selected ? .radioButtonSelected : .radioButton
    }
    
}
