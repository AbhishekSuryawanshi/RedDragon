//
//  LeagueCollectionViewCell.swift
//  RedDragon
//
//  Created by QASR02 on 23/11/2023.
//

import UIKit

class LeagueCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var leagueName: UILabel!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                leagueName.textColor = UIColor.black
                leagueName.font = fontBold(13)
            } else {
                leagueName.textColor = UIColor.darkGray
                leagueName.font = fontRegular(14)
            }
        }
    }
}
