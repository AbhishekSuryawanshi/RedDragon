//
//  WalletViewModel.swift
//  RedDragon
//
//  Created by Qasr01 on 22/12/2023.
//

import Foundation

class WalletVM: APIServiceManager<SubscriptionResponse> {
    init () {}
    static let shared = WalletVM()
    
    var subscriptionArray: [Subscription] = []
    var betsArray: [Int] = [10, 40, 75, 200]
    var heatsArray: [Int] = [10, 20, 50, 100]
    
    ///function to fetch subscriptions in wallet module
    func subscriptionListAsyncCall() {
        let urlString   = URLConstants.subscriptionList
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}

class AddWalletVM: APIServiceManager<AddSubscriptionResponse> {
    init () {}
    static let shared = AddWalletVM()
    
    func addTransaction(parameters: [String: Any]) {
        let urlString   = URLConstants.addSubscription
        let method      = RequestType.post
        asyncCall(urlString: urlString, method: method, parameters: parameters)
    }
}
