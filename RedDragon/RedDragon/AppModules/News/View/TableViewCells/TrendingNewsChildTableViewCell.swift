//
//  TrendingNewsChildTableViewCell.swift
//  RedDragon
//
//  Created by Abdullah on 09/12/2023.
//

import UIKit
import Kingfisher

final class TrendingNewsChildTableViewCell: UITableViewCell {

    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    var viewModel: TrendingChildCellViewModel? {
        didSet{
            guard let viewModel = self.viewModel else { return }
            
            let model = viewModel.model
            titleLabel.text = model.title?.attributedHtmlString?.string ?? "NA"
            timeStampLabel.text = model.createTime?.formatDate2(inputFormat: .ddMMyyyyWithTimeZone)
            newsImageView.kf.setImage(with: URL(string: model.path ?? ""), placeholder: UIImage(named: "empty"))
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
    
    func configureCell(with viewModel: TrendingChildCellViewModel) {
        self.viewModel = viewModel
    }
}
