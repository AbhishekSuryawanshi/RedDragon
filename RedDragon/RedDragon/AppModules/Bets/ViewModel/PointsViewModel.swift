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
            "session": "17ba0791499db908433b80f37c5fbc89b870084b-eeb2319c2c71c4ad5636e0a27ae5a98852275a53", // hard code should to change
            "offset" : 0
        ]
        
        asyncCall(urlString: urlString, method: method, parameters: params)
    }
    
}
