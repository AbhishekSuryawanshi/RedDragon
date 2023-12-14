//
//  NewsDetailTableViewCell.swift
//  RedDragon
//
//  Created by Abdullah on 09/12/2023.
//

import UIKit
import Kingfisher

class NewsDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverImageImageView: UIImageView!
    
    var viewModel: NewsDetailCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            
            let model = viewModel.model
            
            titleLabel.text = model.title?.attributedHtmlString?.string ?? "NA"
            subTitleLabel.text = model.description?.attributedHtmlString?.string ?? "NA"
            dateLabel.text = model.createTime?.formatDate(inputFormat: .ddMMyyyyWithTimeZone, outputFormat: .ddMMyyyy)
            timeLabel.text = model.createTime?.formatDate(inputFormat: .ddMMyyyyWithTimeZone, outputFormat: .hmma)
            contentLabel.text = model.content?.attributedHtmlString?.string ?? "NA"
            coverImageImageView.kf.setImage(with: URL(string: model.path ?? ""))
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
    
    func configureCell(with viewModel: NewsDetailCellViewModel) {
        self.viewModel = viewModel
    }
    
}
