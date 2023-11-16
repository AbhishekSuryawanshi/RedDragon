//
//  HomeTitleCollectionVc.swift
//  RedDragon
//
//  Created by Qoo on 15/11/2023.
//

import UIKit

class HomeTitleCollectionVc: UICollectionViewCell {
    
    
    @IBOutlet var bgView: UIView!
    @IBOutlet var titleLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override var isSelected: Bool{
        didSet{
            if isSelected{
                
                titleLable.textColor = .white
                bgView.backgroundColor = .base
                
            }else{
                
                titleLable.textColor = .base
                bgView.backgroundColor = .white
                
            }
        }
    }

}
