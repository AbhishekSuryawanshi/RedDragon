//
//  SubscriptionTableViewCell.swift
//  RedDragon
//
//  Created by Qasr01 on 18/12/2023.
//

import UIKit

class SubscriptionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCellValues(model: Subscription)  {
        arrowImageView.image = model.type == "c" ? .doubleArrowDown : .doubleArrowUp
        titleLabel.text = model.event.capitalized
        pointsLabel.text = "\(model.coinCount)🔥"
        dateLabel.text = model.updatedTime.formatDate(inputFormat: .yyyyMMddHHmmss, outputFormat: .ddMMMyyyyhmma)
    }
}
