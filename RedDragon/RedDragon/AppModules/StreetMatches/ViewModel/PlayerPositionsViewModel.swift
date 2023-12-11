//
//  PlayerPositionsViewModel.swift
//  RedDragon
//
//  Created by Remya on 12/11/23.
//

import Foundation

class PlayerPositionsViewModel: APIServiceManager<[StreetPlayerPosition]> {
    
    //function to fetch player data
    func getPlayerPositionsAsyncCall() {
        let urlString   = URLConstants.playerPositions
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}
