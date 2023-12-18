//
//  StreetEditProfileViewModel.swift
//  RedDragon
//
//  Created by Remya on 12/15/23.
//

import Foundation

class StreetEditProfileViewModel: APIServiceManager<StreetProfileUserResponse> {
    
    //function to update player profile
    func updateProfileAsyncCall(param:[String:Any]) {
        let urlString   = URLConstants.streetUpdateProfile
        let method      = RequestType.put
        asyncCall(urlString: urlString, method: method, parameters: param)
    }
}


