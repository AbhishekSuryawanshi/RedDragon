//
//  CountryListTableViewCell.swift
//  RedDragon
//
//  Created by Qasr01 on 15/11/2023.
//

import UIKit

class CountryListTableViewCell: UITableViewCell {

    @IBOutlet weak var flagIV: UIImageView!
    @IBOutlet weak var nameLBL: UILabel!
    @IBOutlet weak var codeLBL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
