//
//  UIColllectionViewCell+Extension.swift
//  RedDragon
//
//  Created by Abdullah on 05/12/2023.
//

import UIKit

extension UICollectionViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }
    
    static var nib_Name: UINib {
        UINib(nibName: reuseIdentifier, bundle: nil)
    }
    
    func addShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 2  // Adjust the shadow radius as needed
        self.layer.shadowOpacity = 0.7  // Adjust the shadow opacity as needed
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
}
