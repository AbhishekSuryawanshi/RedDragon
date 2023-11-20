//
//  BetsHoneViewModel.swift
//  RedDragon
//
//  Created by Qoo on 15/11/2023.
//

import Foundation


class BetsHomeViewModel : APIServiceManager<MatchListModel> {
    
    let sports: [Sports] = [.football, .basketball, .tennis, .handball, .hockey, .volleyball]
    
    let homeTitles : [BetsTitleCollectionView] = [.All, .Live, .Win, .Lose]
    
    ///function to fetch All Bet matches
    func fetchAllBetsAsyncCall(sport : Sports, lang: String) {
        let urlString   = URLConstants.betAllMatches
        let method      = RequestType.post
        let myTime = Date.tomorrow
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let tomorrowDate = dateFormatter.string(from: myTime)
                
        let params: [String: Any] = [
            "lang": lang,
            "date": tomorrowDate,
            "sport": sport.rawValue.lowercased(),
            "session": "17ba0791499db908433b80f37c5fbc89b870084b-e4331ab440bcceb12cd89412d77fc2dac53b7a48" // hard code should to change
        ]
        asyncCall(urlString: urlString, method: method, parameters: params)
    }
    
    
}
