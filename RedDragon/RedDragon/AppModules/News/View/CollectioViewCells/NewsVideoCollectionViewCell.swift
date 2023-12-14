//
//  NewsVideoCollectionViewCell.swift
//  RedDragon
//
//  Created by Abdullah on 11/12/2023.
//

import UIKit
import Kingfisher

final class NewsVideoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var bgView: UIView!
    
    var viewModel: NewsVideoCollectionCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            
            let model = viewModel.model
            titleLabel.text = model.title
            newsImageView.kf.setImage(with: URL(string: model.thumbnailPath ?? ""))
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        addShadow()
    }
    
    func configureCell(with viewModel: NewsVideoCollectionCellViewModel) {
        self.viewModel = viewModel
    }

}
