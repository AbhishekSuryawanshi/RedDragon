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
    func fetchAllMatchesAsyncCall(sport : Sports, lang: String, day : String) {
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
                "sport": sport.rawValue.lowercased(),
                "live" : true,
                "session": "17ba0791499db908433b80f37c5fbc89b870084b-eeb2319c2c71c4ad5636e0a27ae5a98852275a53" // hard code should to change
            ]
            asyncCall(urlString: urlString, method: method, parameters: params)
            
        }else{
            let params: [String: Any] = [
                "lang": lang,
                "date": tomorrowDate,
                "sport": sport.rawValue.lowercased(),
                "session": "17ba0791499db908433b80f37c5fbc89b870084b-eeb2319c2c71c4ad5636e0a27ae5a98852275a53" // hard code should to change
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
            "session": "17ba0791499db908433b80f37c5fbc89b870084b-eeb2319c2c71c4ad5636e0a27ae5a98852275a53", // hard code should to change
            "offset" : 0
        ]
        
        asyncCall(urlString: urlString, method: method, parameters: params)
    }
}
