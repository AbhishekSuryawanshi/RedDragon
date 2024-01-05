//
//  CountryTableViewCell.swift
//  RedDragon
//
//  Created by Qasr01 on 04/01/2024.
//

import UIKit

class CountryTableViewCell: UITableViewCell {
  
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCellValues(model: Country) {
        flagImageView.setImage(imageStr: model.flag, placeholder: .placeholderFlag)
        nameLabel.text = model.name
        codeLabel.text = model.phoneCode
    }
}
