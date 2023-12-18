//
//  StreetPlayerProfileViewModel.swift
//  RedDragon
//
//  Created by Remya on 12/14/23.
//

import Foundation

class StreetPlayerProfileViewModel: APIServiceManager<StreetProfileUserResponse> {
    
    //function to fetch player profile
    func getPlayerProfileAsyncCall(id:Int) {
        let urlString   = URLConstants.streetPlayers  + "/\(id)" + "/details"
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}
