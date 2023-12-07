//
//  SenderTableViewCell.swift
//  VinderApp
//
//  Created by iOS Dev on 26/10/2023.
//

import UIKit

class SenderTableViewCell: UITableViewCell {
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    static let identifier = "SenderTableViewCell"
    static func nib() -> UINib{
        return UINib(nibName: "SenderTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
