//
//  LeaderboardViewModel.swift
//  RedDragon
//
//  Created by QASR02 on 28/11/2023.
//

import Foundation

class LeaderboardViewModel: APIServiceManager<Leaderboard> {
    
    func fetchLeaderboardListAsyncCall() {
        let url = URLConstants.cardGame_leaderboard
        let method = RequestType.get
        asyncCall(urlString: url, method: method, parameters: nil, isGuestUser: true, anyDefaultToken: DefaultToken.guestUserCardGame)
    }
    
}
