//
//  CommentTableViewCell.swift
//  RedDragon
//
//  Created by Qasr01 on 28/11/2023.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var deleteButtonHeightConstaint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    ///comments of posts in social module
    func configureSocialComments(model: SocialComment, _index: Int) {
        userImageView.setImage(imageStr: model.user.image, placeholder: .placeholderUser)
        nameLabel.text = "\(model.user.firstName) \(model.user.lastName)"
        commentLabel.text = model.comment
        deleteButton.setTitle("Delete".localized, for: .normal)
        deleteButton.tag = _index
        ///Pass user id of user in euroleague to find comment owner or not
        ///Show delete button for comment owner
        deleteButtonHeightConstaint.constant = (UserDefaults.standard.user?.appDataIDs.euro5LeagueUserId ?? 0) == model.user.id ? 25 : 0
    }
}
