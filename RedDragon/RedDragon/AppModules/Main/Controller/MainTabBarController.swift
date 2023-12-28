//
//  MainTabBarController.swift
//  RedDragon
//
//  Created by Qasr01 on 28/12/2023.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshForLocalization), name: .languageUpdated, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .languageUpdated, object: nil)
    }
    
    @objc func refreshForLocalization()  {
        // Show localized tab names
        tabBar.items?[0].title = StringConstants.home.localized
        tabBar.items?[1].title = StringConstants.social.localized
        tabBar.items?[2].title = StringConstants.database.localized
        tabBar.items?[3].title = StringConstants.wallet.localized
        tabBar.items?[4].title = StringConstants.discover.localized
    }
}
