

import UIKit

class AmenityCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var imgSelection:UIImageView!
    
    var callSelection:(()->Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override var isSelected:Bool{
        didSet{
            //handleSelection()
        }
    }
    
    
    func handleSelection(){
        callSelection?()
        if isSelected{
            imgSelection.image = UIImage(named: "tick")
        }
        
    }

}
