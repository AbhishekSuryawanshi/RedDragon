//
//  PointsViewModel.swift
//  RedDragon
//
//  Created by Qoo on 21/11/2023.
//

import Foundation

class PointsViewModel : APIServiceManager<WalletBalanceModel> {
    
    //function to fetch All transactions
    func fetchPointsAsyncCall(){
        let urlString   = URLConstants.points
        let method      = RequestType.post
        let params: [String: Any] = [
            "session": DefaultToken.session,
            "offset" : 0
        ]
        
        asyncCall(urlString: urlString, method: method, parameters: params)
    }
    
}
