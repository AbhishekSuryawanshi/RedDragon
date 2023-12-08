//
//  LeaderboardDetailViewModel.swift
//  RedDragon
//
//  Created by QASR02 on 05/12/2023.
//

import Foundation

class LeaderboardDetailViewModel: APIServiceManager<LeaderboardDetail> {
    
    func leaderboardDetailAsyncCall(userID: Int) {
        let url = URLConstants.leaderboardDetail + "\(userID)/info"
        let method = RequestType.get
        asyncCall(urlString: url, method: method, parameters: nil, isGuestUser: true, anyDefaultToken: DefaultToken.guestUserCardGame)
    }
    
}
