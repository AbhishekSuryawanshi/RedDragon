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
    
    ///function to fetch subscriptions in wallet module
    func subscriptionListAsyncCall() {
        let urlString   = URLConstants.subscriptionList
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}
