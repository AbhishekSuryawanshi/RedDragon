//
//  ProfileTableViewCell.swift
//  RedDragon
//
//  Created by Qasr01 on 22/12/2023.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var rightImageArrow: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureProfileCellValues(type: SettingType) {
        titleLabel.text = type.rawValue.localized
        titleLabel.font = type == .deleteAccount ? fontSemiBold(18) : fontRegular(17)
        titleLabel.textColor = type == .deleteAccount ? .base : .black
        
        valueLabel.text = ProfileVM.shared.getProfileValue(type: type)
        let nonEditableFields: [SettingType] = [.phone, .email, .userName, .deleteAccount]
        rightImageArrow.isHidden = nonEditableFields.contains(type)
    }
}
