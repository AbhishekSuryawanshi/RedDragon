

import UIKit

class FeedsPlayerTableViewCell: UITableViewCell {
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imageViewPlayer: UIImageView!
    @IBOutlet weak var lblPosition: UILabel!
    @IBOutlet weak var btnAccept: UIButton!
    
    var callAccept:(()->Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        btnAccept.setTitle("Accept".localized, for: .normal)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated) 
    }
    
    func configureCell(obj:Creator?){
        lblName.text = (obj?.firstName ?? "") + " " + (obj?.lastName ?? "")
        let age = StreetMatchPlayerTableViewCell.getDateDiffrence(dateStr: obj?.birthdate ?? "")
        lblAge.text = "\(age) \("Years".localized)"
        lblPosition.text = obj?.player.positionName
//        if Utility.getCurrentLang() == "zh-Hans"{
//            lblPosition.text = obj?.player?.position_name_cn
//        }
        imageViewPlayer.setImage(imageStr: obj?.imgURL ?? "", placeholder: .placeholderUser)
    }
    
    @IBAction func actionAccept(_ sender: Any) {
        callAccept?()
    }
    
}
