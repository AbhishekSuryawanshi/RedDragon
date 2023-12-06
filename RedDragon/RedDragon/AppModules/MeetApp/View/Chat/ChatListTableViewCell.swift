//
//  ChatListTableViewCell.swift
//  VinderApp
//
//  Created by iOS Dev on 26/10/2023.
//

import UIKit

class ChatListTableViewCell: UITableViewCell {

    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    
    static let identifier = "ChatListTableViewCell"
    static func nib() -> UINib{
        return UINib(nibName: "ChatListTableViewCell", bundle: nil)
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
