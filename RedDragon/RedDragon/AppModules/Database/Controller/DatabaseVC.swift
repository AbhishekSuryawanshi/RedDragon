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

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchLeagueDetailViewModel()
    }
    
    func showLoader(_ value: Bool) {
        value ? Loader.activityIndicator.startAnimating() : Loader.activityIndicator.stopAnimating()
    }
}

extension DatabaseVC {

    ///fetch view model for league detail
    func fetchLeagueDetailViewModel() {
        databaseVM = DatabaseViewModel()
        databaseVM?.showError = { [weak self] error in
            //error
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
