

import UIKit

class TeamCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgTeam: UIImageView!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblTeam: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(obj:StreetTeam?){
        lblTeam.text = obj?.name
//        if Utility.getCurrentLang() == "zh-Hans"{
//            lblTeam.text = obj?.name_cn
//
        imgTeam.setImage(imageStr: obj?.logoImgURL ?? "", placeholder: .placeholderTeam)
        lblCountry.text = obj?.address
    }

}
