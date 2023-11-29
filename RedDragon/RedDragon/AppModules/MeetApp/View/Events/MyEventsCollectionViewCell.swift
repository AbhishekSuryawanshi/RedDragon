//
//  MyEventsCollectionViewCell.swift
//  RedDragon
//
//  Created by iOS Dev on 28/11/2023.
//

import UIKit

class MyEventsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var eventImgView: UIImageView!
    @IBOutlet weak var eventNameLbl: UILabel!
    @IBOutlet weak var eventCreatedByUserLbl: UILabel!
    @IBOutlet weak var noOfPeopleJoinedLbl: UILabel!
    @IBOutlet weak var dateTimeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
