//
//  StreetHomeHeaderTableViewCell.swift
//  RedDragon
//
//  Created by Remya on 11/24/23.
//

import UIKit

class StreetHomeHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnMore: UIButton!
    
    var callSelection:(()->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func actionMore(_ sender: Any) {
        callSelection?()
    }
    
}
