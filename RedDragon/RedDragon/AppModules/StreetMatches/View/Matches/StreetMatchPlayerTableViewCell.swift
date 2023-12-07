//
//  StreetMatchPlayerTableViewCell.swift
//  RedDragon
//
//  Created by Remya on 12/6/23.
//

import UIKit

class StreetMatchPlayerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblPlayer: UILabel!
    @IBOutlet weak var imgPlayer: UIImageView!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var lblPosition: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(obj:StreetMatchPlayer?){
        lblPlayer.text = (obj?.firstName ?? "") + " " + (obj?.lastName ?? "")
        imgPlayer.setImage(imageStr: obj?.imgURL ?? "", placeholder: .placeholderUser)
        lblPosition.text = obj?.positionName
        let age = getDateDiffrence(dateStr: obj?.birthdate ?? "")
        lblAge.text = "\(age) \("Years".localized)"
    }
    
    func getDateDiffrence(dateStr:String) -> Int{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat.yyyyMMdd.rawValue
        let dt1 = dateFormatter.date(from: dateStr) ?? Date()
        return Calendar.current.dateComponents([.year], from: dt1, to: Date()).year ?? 0
    }
    
}
