//
//  EventsTableViewCell.swift
//  VinderApp
//
//  Created by ios Dev on 21/09/2023.
//

import UIKit

class ExploreEventsTableViewCell: UITableViewCell {
    
    // MARK: - Outlets & Properties
    
    @IBOutlet weak var eventImgView: UIImageView!
    @IBOutlet weak var eventNameLbl: UILabel!
    @IBOutlet weak var eventCreatedByUserLbl: UILabel!
    @IBOutlet weak var noOfPeopleJoinedLbl: UILabel!
    @IBOutlet weak var dateTimeLbl: UILabel!
    
    // MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
}
