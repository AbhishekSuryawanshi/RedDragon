//
//  NewsDetailCommendableTableViewCell.swift
//  RedDragon
//
//  Created by Abdullah on 28/12/2023.
//

import UIKit

final class NewsDetailCommendableTableViewCell: UITableViewCell {

    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var viewAllTitleLabel: UILabel!
    @IBOutlet weak var commentsTitleLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
