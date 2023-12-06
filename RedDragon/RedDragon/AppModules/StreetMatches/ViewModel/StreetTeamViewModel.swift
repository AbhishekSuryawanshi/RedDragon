//
//  StreetTeamViewModel.swift
//  RedDragon
//
//  Created by Remya on 12/6/23.
//

import Foundation


class StreetTeamViewModel: APIServiceManager<[StreetTeam]> {
    
    //function to fetch team data
    func fetchStreetTeamsAsyncCall(isMyteams:Int) {
        let urlString   = URLConstants.streetTeamList
        let method      = RequestType.get
        let param = ["onlyOwn":isMyteams]
        asyncCall(urlString: urlString, method: method, parameters: param)
    }
    
}


class StreetMyTeamViewModel: APIServiceManager<[StreetTeam]> {
    
    //function to fetch team data
    func fetchMyStreetTeamsAsyncCall(isMyteams:Int) {
        let urlString   = URLConstants.streetTeamList
        let method      = RequestType.get
        let param = ["onlyOwn":isMyteams]
        asyncCall(urlString: urlString, method: method, parameters: param)
    }
    
}
