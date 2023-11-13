//
//  SocialViewModel.swift
//  RedDragon
//
//  Created by Qasr01 on 28/10/2023.
//

import Foundation

class SocialLeagueVM: APIServiceManager<[SocialLeague]> {
    init () {}
    static let shared = SocialLeagueVM()
    
    var leagueArray: [SocialLeague] = []
    
    ///function to fetch league list for social module
    func fetchLeagueListAsyncCall() {
        let urlString   = URLConstants.socialLeague
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}

class SocialTeamVM: APIServiceManager<[SocialTeam]> {
    init () {}
    static let shared = SocialTeamVM()
    var teamArray: [SocialTeam] = []
    
    ///function to fetch team list for social module
    ///Send leagueId parameter to get teams of that league
    func fetchTeamListAsyncCall() {
        let urlString   = URLConstants.socialTeam
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}

class SocialMatchVM: APIServiceManager<SocialMatchResponse> {
    init () {}
    static let shared = SocialMatchVM()
    
    var matchArray: [SocialMatch] = []
    
    ///function to fetch match list for social module
    ///We can send leagueId, teamId, fromDayNum, toDayNum parameter to get filtered matches
    func fetchMatchListAsyncCall(leagueId: String, teamId: String = "") {
        var urlString   = URLConstants.socialMatch + "?leagueId=\(leagueId)&fromDayNum=-5&toDayNum=5"
        if teamId != "" {
            urlString   = URLConstants.socialMatch + "?teamId=\(teamId)&fromDayNum=-5&toDayNum=5"
        }
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}
