//
//  DiscoverViewController.swift
//  RedDragon
//
//  Created by Qoo on 13/11/2023.
//

import UIKit
import Hero
import Combine

class DiscoverViewController: UIViewController {
    
    var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchLoginViewModel()
        gotoCardGameButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func showLoader(_ value: Bool) {
        value ? startLoader() : stopLoader()
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
    
    @IBAction func btnGoToMatches(_ sender: Any) {
        self.goToMatches()
    }
    
    @IBAction func toStreetMatches(_ sender: Any) {
        goToStreetMatches()
    }
    
    @IBAction func btnGoToExperts(_ sender: Any) {
        goToExperts()
    }
      
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        self.customAlertView_2Actions(title: "Logout".localized, description: StringConstants.logoutAlert.localized) {
            LogoutVM.shared.logoutAsyncCall()
        }
    }
    
    @IBAction func newsButtonTapped(_ sender: UIButton) {
        self.tabBarController?.tabBar.isHidden = true
        navigateToViewController(NewsModuleVC.self, storyboardName: StoryboardName.news, identifier: "NewsModuleVC")
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
    
    func goToMatches(){
        navigateToViewController(MatchesDashboardVC.self, storyboardName: StoryboardName.matches, animationType: .autoReverse(presenting: .zoom))
    }
    
    func goToExperts(){
        navigateToViewController(HomeVC.self, storyboardName: StoryboardName.home, animationType: .autoReverse(presenting: .zoom))
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

// MARK: - API Services
extension DiscoverViewController {
    func fetchLoginViewModel() {
        
        LogoutVM.shared.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        LogoutVM.shared.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        LogoutVM.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.execute_onResponseData(response)
            })
            .store(in: &cancellable)
    }
    
    func execute_onResponseData(_ response: LoginResponse?) {
        if let dataResponse = response?.response {
            UserDefaults.standard.user = nil
            UserDefaults.standard.token = nil
            UserDefaults.standard.points = nil
        } else {
            if let errorResponse = response?.error {
                self.view.makeToast(errorResponse.messages?.first ?? CustomErrors.unknown.description, duration: 2.0, position: .center)
            }
        }
    }
}
