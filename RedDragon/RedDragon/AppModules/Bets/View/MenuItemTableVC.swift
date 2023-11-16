//
//  MenuItemTableVC.swift
//  RedDragon
//
//  Created by Qoo on 15/11/2023.
//

import UIKit

class MenuItemTableVC: UITableViewCell {
    
    
    @IBOutlet var cellBg: UIView!
    @IBOutlet var titleLable: UILabel!
    @IBOutlet var imgItem: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if isSelected{
            titleLable.textColor = .white
            cellBg.backgroundColor = .base
        }else{
            titleLable.textColor = .base
            cellBg.backgroundColor = .white
        }
    }
    
 
    
}
