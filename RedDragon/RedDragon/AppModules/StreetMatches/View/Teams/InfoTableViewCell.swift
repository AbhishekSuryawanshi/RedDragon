

import UIKit

class InfoTableViewCell: UITableViewCell {
    @IBOutlet weak var lblKey: UILabel!
    
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var backView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(key:String,value:String){
        lblKey.text = key
        lblValue.text = value
    }
    
}
