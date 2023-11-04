//
//  MatchTabsCollectionViewCell.swift
//  RedDragon
//
//  Created by QASR02 on 04/11/2023.
//

import UIKit

class MatchTabsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tabNameLabel: UILabel!
    @IBOutlet weak var bottomLineView: UIView!
    let selectedColor = UIColor(red: 187/255, green: 25/255, blue: 16/255, alpha: 1)
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                tabNameLabel.textColor = selectedColor
                bottomLineView.backgroundColor = selectedColor
                //tabNameLabel.font = UIFont.boldSystemFont(ofSize: 13)
            } else {
                tabNameLabel.textColor = UIColor.darkGray
                bottomLineView.backgroundColor = UIColor.clear
                //tabNameLabel.font = UIFont.systemFont(ofSize: 13)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
