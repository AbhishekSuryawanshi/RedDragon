//
//  SocialPollTableViewCell.swift
//  RedDragon
//
//  Created by Qasr01 on 01/11/2023.
//

import UIKit

enum PollCellType {
    case createPost
    case pollQuestien
    case pollAnswer
}

class SocialPollTableViewCell: UITableViewCell {

    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var rightWidthConstrant: NSLayoutConstraint!
    @IBOutlet weak var closeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(type: PollCellType, title: String = "", rightViewWidth: CGFloat = 0) {
        leftLabel.textAlignment = type == .pollQuestien ? .center : .left
        closeButton.isHidden = type == .createPost ? false : true
        rightWidthConstrant.constant = type == .pollAnswer ? rightViewWidth : 0
        leftView.backgroundColor = type == .pollAnswer ? .base : .wheat1
    }
}
