//
//  StreetMatchTableViewCell.swift
//  RedDragon
//
//  Created by Remya on 11/23/23.
//

import UIKit

class StreetMatchTableViewCell: UITableViewCell {

    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblHome: UILabel!
    @IBOutlet weak var imgHome: UIImageView!
    @IBOutlet weak var imgAway: UIImageView!
    @IBOutlet weak var lblAwayScore: UILabel!
    @IBOutlet weak var lblHomeScore: UILabel!
    @IBOutlet weak var lblAway: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(obj:StreetMatch?){
        lblLocation.text = obj?.address
        lblHome.text = obj?.homeTeam?.name
        imgHome.setImage(imageStr: obj?.homeTeam?.logoImgURL ?? "")
        imgAway.setImage(imageStr: obj?.awayTeam?.logoImgURL ?? "")
        lblAway.text = obj?.awayTeam?.name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat.yyyyMMddHHmmss.rawValue
        if let dt1 = dateFormatter.date(from: obj?.scheduleTime ?? "") {
            lblTime.text = dt1.formatDate(outputFormat: .ddMMMyyyyhmma)
        }
    }
}
