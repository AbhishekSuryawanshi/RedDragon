
import UIKit

class NewTeamTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblTeam: UILabel!
    @IBOutlet weak var lblLocation: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(obj:StreetTeam?){
        lblTeam.text = obj?.name
        if UserDefaults.standard.language == "zh-Hans"{
            lblTeam.text = obj?.nameCN
        }
        imgLogo.setImage(imageStr: obj?.logoImgURL ?? "", placeholder: .placeholderTeam)
        lblLocation.text = obj?.address
    }
    
}
