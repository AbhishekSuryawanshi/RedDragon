//
//  SocialCommentTableViewCell.swift
//  RedDragon
//
//  Created by Qasr01 on 06/11/2023.
//

import UIKit

class SocialCommentTableViewCell: UITableViewCell {

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
    func configure(model: Social, _index: Int) {
        
        userImageView.setImage(imageStr: model.user.image, placeholder: nil)
        nameLabel.text = "\(model.user.firstName) \(model.user.lastName)"
        commentLabel.text = model.comment
        deleteButton.setTitle("Delete".localized, for: .normal)
        deleteButton.tag = _index
        deleteButtonHeightConstaint.constant = (UserDefaults.standard.user?.id ?? 0) == model.user.id ? 25 : 0
    }
}
