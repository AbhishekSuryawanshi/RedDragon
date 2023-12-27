//
//  StadiumTableViewCell.swift
//  RedDragon
//
//  Created by Remya on 11/23/23.
//

import UIKit

class StadiumTableViewCell: UITableViewCell {

    @IBOutlet weak var imgStadium: UIImageView!
    @IBOutlet weak var lblStadium: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(obj:Stadium?){
        imgStadium.setImage(imageStr: obj?.imgsUrls?.first ?? "", placeholder: .placeholder1)
        lblStadium.text = obj?.name
        lblDescription.text = obj?.description
        lblLocation.text = obj?.address
        if UserDefaults.standard.language == "zh"{
            lblStadium.text = obj?.nameCN
            lblDescription.text = obj?.descriptionCN
        }
    }
}
