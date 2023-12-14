//
//  UITableViewCell+Extension.swift
//  RedDragon
//
//  Created by Abdullah on 05/12/2023.
//

import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }
    
    static var nib_Name: UINib {
        UINib(nibName: reuseIdentifier, bundle: nil)
    }
}
