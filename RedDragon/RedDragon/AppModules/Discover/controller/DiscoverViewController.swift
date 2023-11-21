//
//  DiscoverViewController.swift
//  RedDragon
//
//  Created by Qoo on 13/11/2023.
//

import UIKit

class DiscoverViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    // MARK: - Navigation
    
    @IBAction func btnGoToBets(_ sender: Any) {
        self.goToBets()
    }
    
    @IBAction func btnGoToMeet(_ sender: Any) {
        self.goToMeet()
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        self.customAlertView_2Actions(title: "Logout".localized, description: StringConstants.logoutAlert.localized) {
            UserDefaults.standard.user = nil
            UserDefaults.standard.token = nil
        }
    }
    
    func goToBets(){
        navigateToViewController(BetHomeVc.self, storyboardName: StoryboardName.bets, animationType: .autoReverse(presenting: .zoom))
    }
    
    func goToMeet(){
        navigateToViewController(MeetHomeVC.self, storyboardName: StoryboardName.meet, animationType: .autoReverse(presenting: .zoom))
    }
    
}
