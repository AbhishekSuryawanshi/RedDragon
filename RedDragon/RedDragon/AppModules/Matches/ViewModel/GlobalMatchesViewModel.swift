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

class FootballLeagueMatchesViewModel: APIServiceManager<GlobalEventsModel> {
    ///function to fetch football finished matches
    func fetchFootballLeagueMatches(leagueId: String) {
        let urlString   = URLConstants.footballMatchList + "?hotLeagueId=\(leagueId)"
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}

class BasketballLeaguesViewModel: APIServiceManager<GlobalEventsModel> {
    
    ///function to fetch football live matches
    func fetchBasketballLeagueMatches() {
        let urlString   = URLConstants.basketballMatchList
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}

class BasketballLiveMatchesViewModel: APIServiceManager<GlobalEventsModel> {
    
    ///function to fetch football live matches
    func fetchBasketballLiveMatches() {
        let urlString   = URLConstants.basketballMatchList + "?matchStatus=live"
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}

class BasketballUpcomingMatchesViewModel: APIServiceManager<GlobalEventsModel> {
    ///function to fetch football upcoming matches
    func fetchBasketballUpcomingMatches() {
        let urlString   = URLConstants.basketballMatchList + "?matchStatus=upcoming"
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}

class BasketballFinishedMatchesViewModel: APIServiceManager<GlobalEventsModel> {
    ///function to fetch football finished matches
    func fetchBasketballFinishedMatches() {
        let urlString   = URLConstants.basketballMatchList + "?matchStatus=finished"
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}

class BasketballLeagueMatchesViewModel: APIServiceManager<GlobalEventsModel> {
    ///function to fetch football finished matches
    func fetchBasketballLeagueMatches(leagueId: String) {
        let urlString   = URLConstants.basketballMatchList + "?hotLeagueId=\(leagueId)"
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}

class FootballH2HMatchesViewModel: APIServiceManager<H2HMatchListModel> {
    ///function to fetch football finished matches
    func fetchFootballH2HMatches(matchId: String) {
        let urlString   = URLConstants.footballH2HMatchList + "\(matchId)"
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}

class BasketballH2HMatchesViewModel: APIServiceManager<H2HMatchListModel> {
    ///function to fetch football finished matches
    func fetchBasketballH2HMatches(matchId: String) {
        let urlString   = URLConstants.basketballH2HMatchList + "\(matchId)"
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}

