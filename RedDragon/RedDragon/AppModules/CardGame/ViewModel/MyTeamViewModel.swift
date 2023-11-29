//
//  MyTeamViewModel.swift
//  RedDragon
//
//  Created by QASR02 on 27/11/2023.
//

import Foundation

class MyTeamViewModel: APIServiceManager<MyTeam> {
    
    func fetchmyTeamAsyncCall() {
        let url = URLConstants.cardGame_buyPlayer
        let method = RequestType.get
        asyncCall(urlString: url, method: method, parameters: nil, isGuestUser: true, anyDefaultToken: DefaultToken.guestUserCardGame)
    }
    
}
