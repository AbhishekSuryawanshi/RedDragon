//
//  PlayerLeaguesCollectionViewCell.swift
//  RedDragon
//
//  Created by Ali on 11/16/23.
//

import UIKit

class PlayerLeaguesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var leagueNameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override var isSelected: Bool {
            didSet {
                contentView.backgroundColor = isSelected ? UIColor.init(hex: "FFE08A") : .clear
            }
        }

}
