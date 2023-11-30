//
//  ImageSliderCollectionViewCell.swift
//  RedDragon
//
//  Created by Remya on 11/30/23.
//

import UIKit

class ImageSliderCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    var callLeft:(()->Void)?
    var callRight:(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(){
        let left = UISwipeGestureRecognizer(target : self, action : #selector(Swipeleft))
         left.direction = .left
        self.imageView.addGestureRecognizer(left)
        
        let right = UISwipeGestureRecognizer(target : self, action : #selector(Swiperight))
        right.direction = .right
        self.imageView.addGestureRecognizer(right)
    }
    
    
    @objc func Swipeleft(){
        callLeft?()
    }
    
    @objc func Swiperight(){
        callRight?()
            }
}
