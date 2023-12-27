

import UIKit

class PlayerPositionsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblPlayerPosition: UILabel!
    @IBOutlet weak var txtCount: UITextField!
    
    var updateCount:((Int)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(obj:StreetPlayerPosition?){
        lblPlayerPosition.text = obj?.name
        if UserDefaults.standard.language == "zh"{
            lblPlayerPosition.text = obj?.nameCN
        }
    }
    
    
    @IBAction func actionPlus(_ sender: UIButton) {
        
            if let count = Int(txtCount.text ?? "0"){
                if count < 5{
                txtCount.text = "\(count + 1)"
                    updateCount?(count + 1)
            }
        }
    }
    
    @IBAction func actionMinus(_ sender: Any) {
        if let count = Int(txtCount.text ?? "0"){
            if count > 0{
                txtCount.text = "\(count - 1)"
                updateCount?(count - 1)
            }
        }
    }
    
}
