//
//  LeaderboardViewModel.swift
//  RedDragon
//
//  Created by QASR02 on 28/11/2023.
//

import Foundation

class LeaderboardViewModel: APIServiceManager<Leaderboard> {
    
    func fetchLeaderboardListAsyncCall(isGuest: Bool = false) {
        let url = URLConstants.cardGame_leaderboard
        let method = RequestType.get
        if isGuest {
            asyncCall(urlString: url, method: method, parameters: nil, isGuestUser: true, anyDefaultToken: DefaultToken.guestUserCardGame)
        } else {
            asyncCall(urlString: url, method: method, parameters: nil)
        }
    }
    
}
