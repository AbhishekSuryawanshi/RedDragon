

import UIKit

class TimingsTableViewCell: UITableViewCell {
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblTime: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
//    func configureCell(obj:LocalTimings?){
//        lblDay.text = obj?.day.localized
//        lblTime.text = (obj?.from ?? "") + " " + "To".localized  + " " + (obj?.to ?? "")
//    }
}
