//
//  LatestNewsTableViewCell.swift
//  RedDragon
//
//  Created by Abdullah on 11/12/2023.
//

import UIKit
import Kingfisher

final class LatestNewsTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    
    var viewModel: TrendingNewsCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            let model = viewModel.model
            
            titleLabel.text = model.title?.attributedHtmlString?.string
            timeLabel.text = model.createTime?.formatDate2(inputFormat: .ddMMyyyyWithTimeZone)
            newsImageView.kf.setImage(with: URL(string: model.path ?? ""))
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(with viewModel: TrendingNewsCellViewModel) {
        self.viewModel = viewModel
    }
    
}
