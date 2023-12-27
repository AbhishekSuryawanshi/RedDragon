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
    @IBOutlet weak var btnInfo: UIButton!
    @IBOutlet weak var imgSelection: UIImageView!
    @IBOutlet weak var btnDelete: UIButton!
    
    var callSelection:(()->Void)?
    var callDelete:(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(obj:StreetMatchPlayer?){
        lblPlayer.text = (obj?.firstName ?? "") + " " + (obj?.lastName ?? "")
        imgPlayer.setImage(imageStr: obj?.imgURL ?? "", placeholder: .placeholderUser)
        lblPosition.text = obj?.positionName
        let age = StreetMatchPlayerTableViewCell.getDateDiffrence(dateStr: obj?.birthdate ?? "")
        lblAge.text = "\(age) \("Years".localized)"
        if UserDefaults.standard.language == "zh"{
            lblPosition.text = obj?.positionNameCN
            
        }
    }
    
    class func getDateDiffrence(dateStr:String) -> Int{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat.yyyyMMdd.rawValue
        let dt1 = dateFormatter.date(from: dateStr) ?? Date()
        return Calendar.current.dateComponents([.year], from: dt1, to: Date()).year ?? 0
    }
    
    func handleSelection(selected:Bool){
        if selected{
            imgSelection.isHidden = false
        }
        else{
            imgSelection.isHidden = true
        }
    }
    
    
    @IBAction func actionDetails(_ sender: Any) {
        callSelection?()
    }
    
    
    @IBAction func actionDelete(_ sender: Any) {
        callDelete?()
    }
   
}
