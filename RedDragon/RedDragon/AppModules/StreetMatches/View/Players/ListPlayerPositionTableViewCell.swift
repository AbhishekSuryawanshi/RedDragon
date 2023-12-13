

import UIKit

class ListPlayerPositionTableViewCell: UITableViewCell {
    @IBOutlet weak var lblPlayerPosition: UILabel!
    @IBOutlet weak var lblCount: UILabel!

    @IBOutlet weak var fixedRequired: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        fixedRequired.text = "Required".localized
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(obj:StreetPosition?){
        lblPlayerPosition.text = obj?.positionName
//        if Utility.getCurrentLang() == "zh-Hans"{
//            lblPlayerPosition.text = obj?.position_name_cn
//        }
        lblCount.text = obj?.count
    }
    
}
