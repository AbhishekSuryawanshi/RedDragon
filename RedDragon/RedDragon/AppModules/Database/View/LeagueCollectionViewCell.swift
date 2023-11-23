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
                leagueName.font = UIFont.boldSystemFont(ofSize: 13)
            } else {
                leagueName.textColor = UIColor.darkGray
                leagueName.font = UIFont.systemFont(ofSize: 14)
            }
        }
    }
}
