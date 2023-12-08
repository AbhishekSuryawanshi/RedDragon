//
//  NewsCollectionViewCell.swift
//  RedDragon
//
//  Created by Qasr01 on 25/11/2023.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureGossipCell(model: Gossip) {
        bgView.applyShadow(radius: 10, opacity: 1)
        
        newsImageView.setImage(imageStr: model.mediaSource.last ?? "", placeholder: .empty)
        titleLabel.text = model.title
    }
}
