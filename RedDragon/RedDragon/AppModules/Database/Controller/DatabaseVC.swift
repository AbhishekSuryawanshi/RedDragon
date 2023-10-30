//
//  DatabaseVC.swift
//  RedDragon
//
//  Created by QASR02 on 25/10/2023.
//

import UIKit
import Combine

class DatabaseVC: UIViewController {
    
    var databaseVM: DatabaseViewModel?
    var cancellable = Set<AnyCancellable>()
    var fetchCurrentLanguageCode = String()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var lang = UserDefaults.standard.string(forKey: UserDefaultString.language)  ?? "en"
        lang = (lang == "en-US") ? "en" : lang
        fetchCurrentLanguageCode = lang
        loadFunctionality()
        makeNetworkCall()
    }
    
    func loadFunctionality() {
        self.view.addSubview(Loader.activityIndicator)
        fetchLeagueDetailViewModel()
    }
    
    func showLoader(_ value: Bool) {
        value ? Loader.activityIndicator.startAnimating() : Loader.activityIndicator.stopAnimating()
    }
    
    func makeNetworkCall() {
        guard Reachability.isConnectedToNetwork() else {
            customAlertView(title: ErrorMessage.alert.localized, description: ErrorMessage.networkAlert.localized, image: ImageConstants.alertImage)
            return
        }
        databaseVM?.fetchLeagueDetailAsyncCall(lang: fetchCurrentLanguageCode == "en" ? "en" : "zh", slug: "england-premier-league", season: "")
    }
}

extension DatabaseVC {

    ///fetch view model for league detail
    func fetchLeagueDetailViewModel() {
        databaseVM = DatabaseViewModel()
        databaseVM?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        databaseVM?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        databaseVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] leagueData in
                //self?.collecionView.reloadData()
            })
            .store(in: &cancellable)
    }
    
}
