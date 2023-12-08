//
//  GlobalMatchesViewModel.swift
//  RedDragon
//
//  Created by iOS Dev on 08/12/2023.
//

import Foundation

class FootballLiveMatchesViewModel: APIServiceManager<GlobalEventsModel> {
    
    ///function to fetch football live matches
    func fetchFootballLiveMatches() {
        let urlString   = URLConstants.footballMatchList + "?matchStatus=live"
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}

class FootballUpcomingMatchesViewModel: APIServiceManager<GlobalEventsModel> {
    ///function to fetch football upcoming matches
    func fetchFootballUpcomingMatches() {
        let urlString   = URLConstants.footballMatchList + "?matchStatus=upcoming"
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}

class FootballFinishedMatchesViewModel: APIServiceManager<GlobalEventsModel> {
    ///function to fetch football finished matches
    func fetchFootballFinishedMatches() {
        let urlString   = URLConstants.footballMatchList + "?matchStatus=finished"
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}
