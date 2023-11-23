//
//  MatchesCollectionViewCell.swift
//  VinderApp
//
//  Created by ios Dev on 21/09/2023.
//

import UIKit

class MatchesCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets & Properties
//
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var userLevelLbl: UILabel!
    @IBOutlet weak var userLocationLbl: UILabel!
    @IBOutlet weak var locationIcon: UIImageView!

    // MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

}
