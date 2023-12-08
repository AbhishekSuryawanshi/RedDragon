//
//  StadiumImageCollectionViewCell.swift
//  RedDragon
//
//  Created by Remya on 12/5/23.
//

import UIKit

class StadiumImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgPhoto:UIImageView!
    
    var callDelete:(()->Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func actionDelete(){
        callDelete?()
    }
}
