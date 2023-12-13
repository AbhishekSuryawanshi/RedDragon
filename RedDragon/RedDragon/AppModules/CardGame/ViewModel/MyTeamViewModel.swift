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
        asyncCall(urlString: url, method: method, parameters: nil)
    }
}

extension MyTeamViewModel {
    
    //MARK: Sell player function
    
    func sellPlayerAsyncCall(playerID: Int) {
        let url = URLConstants.removePlayer
        let method = RequestType.delete
        let parameter: [String: Any] = ["playerId": playerID]
        asyncCall(urlString: url, method: method, parameters: parameter)
    }
}
