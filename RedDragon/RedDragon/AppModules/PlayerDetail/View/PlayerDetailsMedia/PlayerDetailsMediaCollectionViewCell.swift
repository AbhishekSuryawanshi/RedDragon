//
//  PlayerDetailsMediaCollectionViewCell.swift
//  RedDragon
//
//  Created by Ali on 11/8/23.
//

import UIKit

class PlayerDetailsMediaCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mediaDetailTitle: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var mediaDetailTxtView: UITextView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var mediaImgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
