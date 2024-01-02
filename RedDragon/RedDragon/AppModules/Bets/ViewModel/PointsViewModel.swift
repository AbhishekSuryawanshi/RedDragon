//
//  PointsViewModel.swift
//  RedDragon
//
//  Created by Qoo on 21/11/2023.
//

import Foundation

class PointsViewModel : APIServiceManager<WalletBalanceModel> {
    
    static let shared = PointsViewModel()
    
    //function to fetch All transactions
    func fetchPointsAsyncCall(params: [String: Any]) {
        let urlString   = URLConstants.points
        let method      = RequestType.post
        
        asyncCall(urlString: urlString, method: method, parameters: params)
    }
    
}
