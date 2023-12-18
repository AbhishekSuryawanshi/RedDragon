//
//  HomePagePredictionVM.swift
//  RedDragon
//
//  Created by QASR02 on 18/12/2023.
//

import Foundation

class HomePagePredictionVM: APIServiceManager<HomePagePredictionData> {
    
    ///fetch prediction matches data
    func fetchHomePagePredictionMatchesAsyncCall(lang: String, date: String) {
        let url     = URLConstants.predictionGetMatchList
        let method  = RequestType.get
        // Add the query parameters to the URL components
                let queryItems = [
                    URLQueryItem(name: "sportType", value: "football"),
                    URLQueryItem(name: "lang", value: lang),
                    URLQueryItem(name: "timeZone", value: "+08:00"),
                    URLQueryItem(name: "date", value: date)
                ]
                
                var urlComponents = URLComponents(string: url)
                urlComponents?.queryItems = queryItems
                        
        asyncCall(urlString: (urlComponents?.string)!, method: method, parameters: nil, isGuestUser: true, anyDefaultToken: DefaultToken.guestUserCardGame)
    }

}
