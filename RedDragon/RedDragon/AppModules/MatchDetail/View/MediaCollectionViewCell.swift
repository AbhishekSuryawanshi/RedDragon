//
//  MediaCollectionViewCell.swift
//  RedDragon
//
//  Created by QASR02 on 15/11/2023.
//

import UIKit
import SDWebImage

class MediaCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var overviewImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureMediaData(data: Media) {
        overviewImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        overviewImageView.sd_setImage(with: URL(string: data.preview))
        titleLabel.text = data.title
        dateLabel.text = data.date
    }

}
