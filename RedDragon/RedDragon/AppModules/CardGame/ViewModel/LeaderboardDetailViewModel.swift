//
//  LeaderboardDetailViewModel.swift
//  RedDragon
//
//  Created by QASR02 on 05/12/2023.
//

import Foundation

class LeaderboardDetailViewModel: APIServiceManager<LeaderboardDetail> {
    
    func leaderboardDetailAsyncCall(userID: Int, isGuest: Bool = false) {
        let url = URLConstants.leaderboardDetail + "\(userID)/info"
        let method = RequestType.get
        if isGuest {
            asyncCall(urlString: url, method: method, parameters: nil, isGuestUser: true, anyDefaultToken: DefaultToken.guestUserCardGame)
        } else {
            asyncCall(urlString: url, method: method, parameters: nil)
        }
    }
    
}
