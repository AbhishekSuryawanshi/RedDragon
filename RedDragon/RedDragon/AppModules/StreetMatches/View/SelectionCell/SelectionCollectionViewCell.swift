

import UIKit

class SelectionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override var isSelected: Bool{
        didSet{
            handleSelection()
        }
    }
    
    func handleSelection(){
        
        if isSelected{
            backView.backgroundColor = .yellow4
            lblTitle.textColor = .black
        }
        else{
            backView.backgroundColor = .clear
            lblTitle.textColor = .yellow4
        }
        
    }

}
