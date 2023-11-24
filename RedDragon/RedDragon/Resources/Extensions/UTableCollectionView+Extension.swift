//
//  UTableCollectionView+Extension.swift
//  RedDragon
//
//  Created by Qasr01 on 24/11/2023.
//

import UIKit

extension UITableView {
    /// Register a cell from external xib into a table instance.
    func register(_ nibName: String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        self.register(nib, forCellReuseIdentifier: nibName)
    }
    
    /// To show placeholder text in tableview if date is empty
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 100, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message.localized
        messageLabel.textColor = .darkGray
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = fontRegular(15)
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel;
    }
    ///To remove placeholder text
    func restore() {
        self.backgroundView = nil
    }
}

extension UICollectionView {
    /// Register a cell from external xib into a collection instance.
    func register(_ nibName: String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: nibName)
    }
    
    /// To show placeholder text in collectionview if date is empty
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 100, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message.localized
        messageLabel.textColor = .darkGray
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = fontRegular(15)
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel;
    }
    ///To remove placeholder text
    func restore() {
        self.backgroundView = nil
    }
}
