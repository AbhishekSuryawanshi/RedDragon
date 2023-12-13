//
//  MatchesViewModel.swift
//  RedDragon
//
//  Created by QASR02 on 05/12/2023.
//

import Foundation

class MatchesViewModel: APIServiceManager<YourMatches> {
    
    func yourMatchesAsyncCall(isGuest: Bool = false) {
        let urlString = URLConstants.yourMatches //+ "?onlyOwn=true"
        let method = RequestType.get
        if isGuest {
            asyncCall(urlString: urlString, method: method, parameters: nil, isGuestUser: true, anyDefaultToken: DefaultToken.guestUserCardGame)
        } else {
            asyncCall(urlString: urlString, method: method, parameters: nil)
        }
    }
    
}
