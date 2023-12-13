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
        var urlString   = URLConstants.streetTeamList
        let method      = RequestType.get
        let queryItems = [
            URLQueryItem(name: "onlyOwn", value: String(isMyteams))
        ]
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = queryItems
        urlString = urlComponents?.string ?? ""
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}


class StreetMyTeamViewModel: APIServiceManager<[StreetTeam]> {
    
    //function to fetch team data
    func fetchMyStreetTeamsAsyncCall(isMyteams:Int) {
        var urlString   = URLConstants.streetTeamList
        let method      = RequestType.get
        let queryItems = [
            URLQueryItem(name: "onlyOwn", value: String(isMyteams))
        ]
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = queryItems
        urlString = urlComponents?.string ?? ""
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}
