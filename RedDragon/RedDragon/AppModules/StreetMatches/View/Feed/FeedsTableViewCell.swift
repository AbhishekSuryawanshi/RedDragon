//
//  FeedsTableViewCell.swift
//  RedDragon
//
//  Created by Remya on 11/23/23.
//

import UIKit

class FeedsTableViewCell: UITableViewCell {

    @IBOutlet weak var imgFeed: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPost: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(obj:StreetEvent?){
        imgFeed.setImage(imageStr: obj?.eventImgURL ?? "")
        imgUser.setImage(imageStr: obj?.creatorImgURL ?? "")
        let tp = FeedsType(rawValue: obj?.type ?? "")
        lblTitle.text = tp?.description
        lblDate.text = obj?.createdAt
        lblPost.text = obj?.description
        lblUser.text = obj?.creatorName
        lblLocation.text = obj?.address
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat.ddMMyyyyWithTimeZone.rawValue
        if let dt1 = dateFormatter.date(from: obj?.createdAt ?? "") {
            lblDate.text = dt1.formatDate(outputFormat: .ddMMyyyy)
        }
        if UserDefaults.standard.language == "zh"{
            lblPost.text = obj?.descriptionCN
            
        }
    }
    
}
