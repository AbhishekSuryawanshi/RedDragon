//
//  FeedsTableViewCell.swift
//  RedDragon
//
//  Created by Remya on 11/23/23.
//

import UIKit

class FeedsTableViewCell: UITableViewCell {

    @IBOutlet weak var imgFeed: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPost: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
