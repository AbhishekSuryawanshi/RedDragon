//
//  AllPlayersViewController.swift
//  RedDragon
//
//  Created by QASR02 on 20/11/2023.
//

import UIKit
import Combine

class AllPlayersViewController: UIViewController {
    
    var cancellable = Set<AnyCancellable>()
    var allPlayersVM: AllFootballPlayersViewModel?
    var fetchCurrentLanguageCode = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadFunctionality()
    }
    
    func loadFunctionality() {
        addActivityIndicator()
        checkLocalisation()
        fetchAllPlayersViewModel()
    }
    
    func fetchAllPlayersViewModel() {
        allPlayersVM = AllFootballPlayersViewModel.shared ///Singleton shared instance
        allPlayersVM?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        allPlayersVM?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        allPlayersVM?.$allPlayers
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] player in
//                self?.tableView.reloadData()
//                let guest = UserDefaults.standard.bool(forKey: UserDefault.guestUser)
//                if !guest {
//                    self?.fetchMyTeamViewModel()
//                }
            })
            .store(in: &cancellable)
        
        makeAPICall()
    }
    
    func makeAPICall() {
        guard Reachability.isConnectedToNetwork() else {
            customAlertView(title: ErrorMessage.alert.localized, description: ErrorMessage.networkAlert.localized, image: ImageConstants.alertImage)
            return
        }
        allPlayersVM?.performInitialAPICallIfNeeded()
    }
    
    func showLoader(_ value: Bool) {
        value ? Loader.activityIndicator.startAnimating() : Loader.activityIndicator.stopAnimating()
    }

}

/// __Supportive function calls
extension AllPlayersViewController {
    
    func addActivityIndicator() {
        self.view.addSubview(Loader.activityIndicator)
    }
    
    func checkLocalisation() {
        var lang = UserDefaults.standard.string(forKey: UserDefaultString.language) ?? "en"
        lang = (lang == "en-US") ? "en" : lang
        fetchCurrentLanguageCode = lang
    }
}
