//
//  UserPlayersCollectionCell.swift
//  RedDragon
//
//  Created by QASR02 on 09/12/2023.
//

import UIKit

class UserPlayersCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var arraowImage: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backView.layer.borderColor = UIColor(displayP3Red: 187/255, green: 25/255, blue: 16/255, alpha: 1).cgColor
                backView.layer.borderWidth = 0.7
                backView.layer.masksToBounds = true
                arraowImage.image = UIImage(named: "checkAbility")
            } else {
                backView.layer.borderColor = UIColor.clear.cgColor
                backView.layer.borderWidth = 1
                backView.layer.masksToBounds = true
                arraowImage.image = nil
            }
        }
    }
    
}
