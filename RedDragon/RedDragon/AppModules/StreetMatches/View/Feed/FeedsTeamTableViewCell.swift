

import UIKit

class FeedsTeamTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblTeam: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var btnAccept: UIButton!
    
    
    var callAccept:(()->Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnAccept.setTitle("Accept".localized, for: .normal)
    }
    
    @IBAction func actionAccept(_ sender: Any) {
        callAccept?()
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    func configureCell(obj:StreetTeam?){
        lblTeam.text = obj?.name
//        if Utility.getCurrentLang() == "zh-Hans"{
//            lblTeam.text = obj?.name_cn
//        }
        imgLogo.setImage(imageStr: obj?.logoImgURL ?? "", placeholder: .placeholderTeam)
        lblLocation.text = obj?.address
    }
    
}
