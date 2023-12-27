//
//  NoDataTableViewCell.swift
//  RedDragon
//
//  Created by iOS Dev on 25/12/2023.
//

import UIKit

class NoDataTableViewCell: UITableViewCell {
    @IBOutlet weak var noDataImageView: UIImageView?
    @IBOutlet weak var noDataLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(image: String? = "", message: String? = "No Data") {
        noDataImageView?.setImage(imageStr: image!, placeholder: .empty)
        noDataLabel?.text = message
    }
}
