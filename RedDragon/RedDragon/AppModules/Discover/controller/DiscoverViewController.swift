//
//  DiscoverViewController.swift
//  RedDragon
//
//  Created by Qoo on 13/11/2023.
//

import UIKit
import Hero

class DiscoverViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gotoCardGameButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Navigation
    @IBAction func goToPredictions(_ sender: Any) {
        goToPredict()
    }
    
    @IBAction func btnGoToBets(_ sender: Any) {
        self.goToBets()
    }
    
    @IBAction func btnGoToMeet(_ sender: Any) {
        self.goToMeet()
    }
    
    
    @IBAction func toStreetMatches(_ sender: Any) {
        goToStreetMatches()
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
        navigateToViewController(MeetDashboardVC.self, storyboardName: StoryboardName.meet, animationType: .autoReverse(presenting: .zoom))
    }
    
    func goToPredict(){
        navigateToViewController(HomePredictionViewController.self, storyboardName: StoryboardName.prediction, animationType: .autoReverse(presenting: .zoom))
    }
    
    func goToStreetMatches(){
        navigateToViewController(StreetMatchesDashboardVC.self, storyboardName: StoryboardName.streetMatches, animationType: .autoReverse(presenting: .zoom))
    }
}

///Card Game module entry point
extension DiscoverViewController {
    
    func gotoCardGameButton() {
        let cardGameButton = UIButton(type: .system)
        cardGameButton.setTitle("Card Game", for: .normal)
        let buttonSize = CGSize(width: 200, height: 40)
        let centerX = view.bounds.midX
        cardGameButton.frame = CGRect(x: centerX - buttonSize.width / 2, y: 200, width: buttonSize.width, height: buttonSize.height)
        cardGameButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        view.addSubview(cardGameButton)
    }
    
    @objc func buttonTapped() {
        self.tabBarController?.tabBar.isHidden = true
        navigateToViewController(AllPlayersViewController.self, storyboardName: StoryboardName.cardGame, identifier: "AllPlayersViewController")
    }
}
