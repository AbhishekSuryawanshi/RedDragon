//
//  NewsTableViewCell.swift
//  RedDragon
//
//  Created by Qasr01 on 27/11/2023.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureGossipCell(model: Gossip) {
        newsImageView.setImage(imageStr: model.mediaSource.last ?? "", placeholder: .empty)
        titleLabel.text = model.title
    }
    
}
