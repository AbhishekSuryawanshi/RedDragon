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
    
    func popupCustomAlert(title: String, description: String, animation: HeroDefaultAnimationType = .autoReverse(presenting: .zoom)) {
        UserDefaults.standard.setValue(title, forKey: UserDefaultString.title)
        UserDefaults.standard.setValue(description, forKey: UserDefaultString.description)
        presentToViewController(CustomAlertVC.self, storyboardName: StoryboardName.customAlert, animationType: animation)
    }
    
}
