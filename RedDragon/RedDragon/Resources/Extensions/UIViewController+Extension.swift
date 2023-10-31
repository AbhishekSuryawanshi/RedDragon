//
//  UIViewController+Extension.swift
//  RedDragon
//
//  Created by QASR02 on 25/10/2023.
//

import UIKit
import Hero

extension UIViewController {
    
    func viewShadow(_ view: UIView, color: UIColor, opacity: Float) {
        view.layer.cornerRadius = 15
        view.layer.shadowColor = color.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = opacity
        view.layer.masksToBounds = true
        view.clipsToBounds = false
    }
    
    func customAlertView(title: String, description: String, image: String){
        let alertVC = PMAlertController(title: title, description: description, image: UIImage(named: image), style: .alert)
        alertVC.addAction(PMAlertAction(title: StringConstants.dismiss.localized, style: .default, action: { () in
                    print("Capture action dismiss")
                }))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    /// __Alert action function for multiple action buttons
    func customAlertView(title: String, description: String, image: String, actions: [PMAlertAction]) {
        let alertVC = PMAlertController(title: title, description: description, image: UIImage(named: image), style: .alert)
        for action in actions {
            alertVC.addAction(action)
        }
        self.present(alertVC, animated: true, completion: nil)
    }
    
    //Use
    /*
     let okAction = PMAlertAction(title: "OK", style: .default) {
         print("OK button tapped")
     }

     let cancelAction = PMAlertAction(title: "Cancel", style: .cancel) {
         print("Cancel button tapped")
     }

     customAlertView(title: "Alert Title", description: "Alert Description", image: "alertImage", actions: [okAction, cancelAction])

     */

    
    func defineTableViewNibCell(tableView: UITableView, cellName: String) {
        let nib = UINib(nibName: cellName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellName)
    }
    
}
