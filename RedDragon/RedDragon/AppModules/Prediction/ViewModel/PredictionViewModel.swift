//
//  PredictionViewModel.swift
//  RedDragon
//
//  Created by Ali on 11/23/23.
//

import Foundation

class PredictionViewModel: APIServiceManager<PredictionMatchesModel> {
    
    ///fetch prediction matches data
    func fetchPredictionMatchesAsyncCall(lang: String, date: String, sportType: String) {
        let url     = URLConstants.predictionBaseURL + URLConstants.getMatchesList
        let method  = RequestType.get
        // Add the query parameters to the URL components
                let queryItems = [
                    URLQueryItem(name: "sportType", value: sportType),
                    URLQueryItem(name: "lang", value: lang),
                    URLQueryItem(name: "date", value: date)
                ]
                
                var urlComponents = URLComponents(string: url)
                urlComponents?.queryItems = queryItems
                
                guard let url = urlComponents?.url else {return  }
        
        asyncCall(urlString: (urlComponents?.string)!, method: method, parameters: nil, isGuestUser: true)
    }
}
