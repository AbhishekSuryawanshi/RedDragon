

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
        if UserDefaults.standard.language == "zh"{
            lblTeam.text = obj?.nameCN
        }

        imgTeam.setImage(imageStr: obj?.logoImgURL ?? "", placeholder: .placeholderTeam)
        lblCountry.text = obj?.address
    }

}
