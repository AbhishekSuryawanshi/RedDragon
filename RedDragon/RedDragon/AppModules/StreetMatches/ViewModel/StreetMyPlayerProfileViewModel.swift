//
//  StreetMyPlayerProfileViewModel.swift
//  RedDragon
//
//  Created by Remya on 12/14/23.
//

import Foundation

class StreetMyPlayerProfileViewModel: APIServiceManager<StreetProfileUser> {
    
    //function to fetch my player profile
    func getMyProfileAsyncCall() {
        let urlString   = URLConstants.streetPlayerProfile
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}
