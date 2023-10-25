//
//  ToggleTabbarNames.swift
//  RedDragon
//
//  Created by QASR02 on 24/10/2023.
//

import UIKit

extension UIViewController {
    
    @MainActor
    func changeTabbarName() {
        
        let tabbarItemTitles = [
            StringConstants.home.localized,
            StringConstants.social.localized,
            StringConstants.database.localized,
            StringConstants.wallet.localized,
            StringConstants.discover.localized
        ]
        
        if let viewControllers = self.tabBarController?.viewControllers {
            for (index, tabbarItemTitle) in tabbarItemTitles.enumerated() {
                if index < viewControllers.count, let tabBarItem = viewControllers[index].tabBarItem {
                    tabBarItem.title = tabbarItemTitle
                }
            }
        }
    }
    
}
