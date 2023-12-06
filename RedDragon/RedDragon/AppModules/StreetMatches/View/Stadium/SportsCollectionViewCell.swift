

import UIKit

class SportsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var imgIcon:UIImageView!
    @IBOutlet weak var lblSport:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(selected:Bool,sport:SportTypes){
        if selected{
            backView.backgroundColor = .base
            lblSport.textColor = .white
            imgIcon.image = sport.imageWhite
            
        }
        else{
            backView.backgroundColor = .white
            lblSport.textColor = .base
            imgIcon.image = sport.image
        }
    }

}
