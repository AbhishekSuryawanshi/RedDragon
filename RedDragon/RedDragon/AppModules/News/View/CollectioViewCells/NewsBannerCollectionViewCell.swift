//
//  NewsBannerCollectionViewCell.swift
//  RedDragon
//
//  Created by Abdullah on 07/12/2023.
//

import UIKit
import Kingfisher

final class NewsBannerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bannerImageView: UIImageView!
    
    var viewModel: NewsCollectionCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            
            let model = viewModel.model
            titleLabel.text = model.title?.attributedHtmlString?.string
            dateLabel.text = model.createTime?.formatDate(inputFormat: .ddMMyyyyWithTimeZone, outputFormat: .ddMMyyyy)
            timeLabel.text = model.createTime?.formatDate(inputFormat: .ddMMyyyyWithTimeZone, outputFormat: .hmma)
            bannerImageView.kf.setImage(with: URL(string: model.path ?? ""))
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(with viewModel: NewsCollectionCellViewModel) {
        self.viewModel = viewModel
    }
}
