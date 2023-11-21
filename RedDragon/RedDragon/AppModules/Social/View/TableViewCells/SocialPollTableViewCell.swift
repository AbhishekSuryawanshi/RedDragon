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
    @IBOutlet weak var leftWidthConstrant: NSLayoutConstraint!
    @IBOutlet weak var stackWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var pollStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(type: PollCellType, poll: Poll, pollCount: Int = 0) {
        
        closeButton.isHidden = type == .createPost ? false : true
        pollStackView.borderWidth = type == .createPost ? 0 : 1
        leftView.borderWidth = type == .createPost ? 1 : 0
        
        let pollViewWidth = type == .createPost ? (screenWidth - 46) : (screenWidth - 30)
        stackWidthConstraint.constant = pollViewWidth
        leftWidthConstrant.constant = pollViewWidth
        if pollCount != 0 {
            
            let ansPercentage = CGFloat((poll.count * 100) / pollCount)
            let lefttViewWidth = (ansPercentage * 0.01) * pollViewWidth
            leftWidthConstrant.constant = type == .pollAnswer ? lefttViewWidth : pollViewWidth
            rightLabel.text = type == .pollAnswer ? "\(ansPercentage == 0.0 ? 0 : ansPercentage)%" : ""
            rightLabel.text = rightLabel.text?.replacingOccurrences(of: ".0%", with: "%")
        } else {
            rightLabel.text = ""
        }
        
        leftView.backgroundColor = type == .pollAnswer ? .base : .wheat1
        leftLabel.textColor = type == .pollAnswer ? .black : .yellow2
        leftLabel.textAlignment = type == .pollQuestien ? .center : .left
        leftLabel.text = poll.title
    }
}
