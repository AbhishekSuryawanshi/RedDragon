//
//  CardGamePlayerDetailVC.swift
//  RedDragon
//
//  Created by QASR02 on 22/11/2023.
//

import UIKit
import Combine
import SDWebImage

class CardGamePlayerDetailVC: UIViewController {
    
    var cancellable = Set<AnyCancellable>()
    var playerDetailVM: PlayerDetailViewModel?
    var lang = String()
    var slug = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadFunctionality()
    }
    
    private func loadFunctionality() {
        addActivityIndicator()
    }
    
    private func makeNetworkCall() {
        lang = UserDefaults.standard.string(forKey: UserDefaultString.language) ?? "en"
        lang = (lang.contains("zh")) ? "zh" : "en"
        playerDetailVM?.fetchPlayerDetailAsyncCall(lang: lang, slug: slug)
    }
}

/// __fetch Players View model
extension CardGamePlayerDetailVC {
    
    private func fetchPlayerViewModel() {
        playerDetailVM = PlayerDetailViewModel()
        playerDetailVM?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        playerDetailVM?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        playerDetailVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] details in
                print(details as Any)
            })
            .store(in: &cancellable)
        
        makeNetworkCall()
    }
}

/// __Supportive function
extension CardGamePlayerDetailVC {
    
    func addActivityIndicator() {
        self.view.addSubview(Loader.activityIndicator)
    }
    
    private func showLoader(_ value: Bool) {
        value ? Loader.activityIndicator.startAnimating() : Loader.activityIndicator.stopAnimating()
    }
}
