//
//  BetsHoneViewModel.swift
//  RedDragon
//
//  Created by Qoo on 15/11/2023.
//

import Foundation


class BetMatchesHomeViewModel : APIServiceManager<MatchListModel> {
    
    let sports: [Sports] = [.football, .basketball, .tennis, .handball, .hockey, .volleyball]
    
    let homeTitles : [BetsTitleCollectionView] = [.All, .Live, .Win, .Lose]
    
    
    //function to fetch All Bet matches
    func fetchAllMatchesAsyncCall(sport : String, lang: String, day : String) {
        let urlString   = URLConstants.betAllMatches
        let method      = RequestType.post
        var myTime : Date?
        
        if day == "today"{
            myTime = Date.today
        }else{
            myTime = Date.tomorrow
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let tomorrowDate = dateFormatter.string(from: myTime!)
        
        
        if day == "today"{
            let params: [String: Any] = [
                "lang": lang,
                "date": tomorrowDate,
                "sport": sport,
                "live" : true,
                
            ]
            asyncCall(urlString: urlString, method: method, parameters: params)
            
        }else{
            let params: [String: Any] = [
                "lang": lang,
                "date": tomorrowDate,
                "sport": sport,
            ]
            asyncCall(urlString: urlString, method: method, parameters: params)
            }
}
    
    
}

 class BetsHomeViewModel : APIServiceManager<BetListModel> {
    //function to fetch All Bet matches
    func fetchAllBetsAsyncCall(){
        let urlString   = URLConstants.allBets
        let method      = RequestType.post
        let params: [String: Any] = [
            "offset" : 0
        ]
        
        asyncCall(urlString: urlString, method: method, parameters: params)
    }
}
