//
//  GlobalMatchOddsTableViewCell.swift
//  RedDragon
//
//  Created by iOS Dev on 12/12/2023.
//

import UIKit

class GlobalMatchOddsTableViewCell: UITableViewCell {
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var awayLabel: UILabel!
    @IBOutlet weak var handicapLabel: UILabel!
    @IBOutlet weak var headingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
