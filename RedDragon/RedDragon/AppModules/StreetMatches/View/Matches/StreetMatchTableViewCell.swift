//
//  StreetMatchTableViewCell.swift
//  RedDragon
//
//  Created by Remya on 11/23/23.
//

import UIKit

class StreetMatchTableViewCell: UITableViewCell {

    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblHome: UILabel!
    @IBOutlet weak var imgHome: UIImageView!
    @IBOutlet weak var imgAway: UIImageView!
    @IBOutlet weak var lblAwayScore: UILabel!
    @IBOutlet weak var lblHomeScore: UILabel!
    @IBOutlet weak var lblAway: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
