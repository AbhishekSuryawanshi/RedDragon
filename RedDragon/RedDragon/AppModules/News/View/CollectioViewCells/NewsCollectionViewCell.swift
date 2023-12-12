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
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var videoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        newsImageView.roundCornersWithBorderLayer(cornerRadii: 10, corners: [.topLeft, .topRight], bound: newsImageView.bounds)
        newsImageView.layoutIfNeeded()
        videoImageView.roundCornersWithBorderLayer(cornerRadii: 10, corners: [.topLeft, .topRight], bound: newsImageView.bounds)
        videoImageView.layoutIfNeeded()
        self.applyShadow(radius: 3, opacity: 0.3, offset: CGSize(width: 1, height: 1))
    }
    
    func configureGossipImageCell(model: Gossip) {
        newsImageView.setImage(imageStr: model.mediaSource.last ?? "", placeholder: .empty)
        titleLabel.text = model.title
//        newsImageView.roundCornersWithBorderLayer(cornerRadii: 10, corners: [.topLeft, .topRight], bound: newsImageView.bounds)
//        newsImageView.layoutIfNeeded()
        videoView.isHidden = true
    }
    
    func configureGossipVideoCell(model: GossipVideo) {
        videoImageView.setImage(imageStr: model.cover, placeholder: .empty)
        titleLabel.text = model.title
        newsImageView.isHidden = true
       // videoImageView.roundCornersWithBorderLayer(cornerRadii: 10, corners: [.topLeft, .topRight], bound: newsImageView.bounds)
       // videoImageView.layoutIfNeeded()
       // self.applyShadow(radius: 3, opacity: 0.3, offset: CGSize(width: 1, height: 1))
    }
    
}
