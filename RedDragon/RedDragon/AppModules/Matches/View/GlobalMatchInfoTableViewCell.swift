//
//  GlobalMatchDetailTableViewCell.swift
//  RedDragon
//
//  Created by iOS Dev on 11/12/2023.
//

import UIKit

class GlobalMatchInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var awayLabel: UILabel!
    @IBOutlet weak var indicatorHeadingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
