//
//  NewsHeaderTableViewCell.swift
//  RedDragon
//
//  Created by Abdullah on 13/12/2023.
//

import UIKit

final class NewsHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(with title: String) {
        self.titleLabel.text = title
    }
    
}
