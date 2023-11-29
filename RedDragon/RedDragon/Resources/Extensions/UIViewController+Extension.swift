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
    
    func customAlertView_2Actions(title: String, description: String, image: UIImage = UIImage.alert, okBTNTitle: String = StringConstants.continue_, okAction:@escaping () -> Void) {
        let alertVC = PMAlertController(title: title.localized, description: description.localized, image: image, style: .alert)
        alertVC.addAction(PMAlertAction(title: okBTNTitle.localized, style: .default, action: { () in
            print("Capture continue action")
            okAction()
        }))
        alertVC.addAction(PMAlertAction(title: StringConstants.dismiss.localized, style: .cancel))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func appPermissionAlert(type: String) {
        customAlertView_2Actions(title: "Settings", description: "\("Please enable your ".localized)\(type.localized)\(" in Settings to continue".localized)") {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
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
    
    func formatNumber(_ number: Double) -> String {
        let thousand = 1000.0
        let million = 1000000.0
        let billion = 1000000000.0

        if number >= billion {
            return String(format: "%.1fB", number / billion)
        } else if number >= million {
            return String(format: "%.1fM", number / million)
        } else if number >= thousand {
            return String(format: "%.1fK", number / thousand)
        } else {
            return "\(Int(number))"
        }
    }
    
    func valueFromAbbreviation(_ valueString: String) -> Double? {
        // Define the suffixes and their respective multipliers
        let suffixes: [Character: Double] = [
            "K": 1e3, // Thousand
            "M": 1e6, // Million
            "B": 1e9, // Billion
            "T": 1e12 // Trillion
        ]
        var result: Double?
        // Extract the numerical value from the input string
        let numericalValue = valueString.dropLast()
        // Check if the last character is a valid suffix
        if let suffix = valueString.last,
           let multiplier = suffixes[suffix] {
            // Attempt to convert the numerical value to a Double
            if let numericalDouble = Double(numericalValue) {
                result = numericalDouble * multiplier
            }
        }
        return result
    }
    
    public func showDiscoverTabOnDismiss() {
        if let window = UIApplication.shared.windows.first {
            window.rootViewController?.dismiss(animated: false, completion: {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabView") as? UITabBarController {
                    let viewControllerIndexToShow = 4
                    if viewControllerIndexToShow < tabBarController.viewControllers?.count ?? 0 {
                        tabBarController.selectedIndex = viewControllerIndexToShow
                        window.rootViewController?.present(tabBarController, animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
}
