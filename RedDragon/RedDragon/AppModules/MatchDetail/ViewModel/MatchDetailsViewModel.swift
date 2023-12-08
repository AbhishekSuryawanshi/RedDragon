//
//  MatchDetailsViewModel.swift
//  RedDragon
//
//  Created by QASR02 on 02/11/2023.
//

import Foundation

class MatchDetailsViewModel: APIServiceManager<MatchDetail> {
    
    ///fetch match details data
    func fetchMatchDetailAsyncCall(lang: String, slug: String, sports: String) {
        let url     = URLConstants.databaseMatchDetail
        let method  = RequestType.post
        let parameters: [String: Any] = ["lang": lang, "slug": slug, "sport": sports, "timezone": "+08:00"]
        asyncCall(urlString: url, method: method, parameters: parameters)
    }
}

class TennisDetailsViewModel: APIServiceManager<TennisMatchDetail> {
    
    ///fetch match details data
    func fetchMatchDetailAsyncCall(lang: String, slug: String, sports: String) {
        let url     = URLConstants.databaseMatchDetail
        let method  = RequestType.post
        let parameters: [String: Any] = ["lang": lang, "slug": slug, "sport": sports, "timezone": "+08:00"]
        asyncCall(urlString: url, method: method, parameters: parameters)
    }
}

class AnalysisViewModel: APIServiceManager<AnalysisModel> {
    
    ///fetch analysis data
    func fetchPredictionAnalysisAsyncCall(matchID: String) {
        let url     = URLConstants.predictionBaseURL + URLConstants.analysisURL
        let method  = RequestType.get
        let queryItems = [
           URLQueryItem(name: "matchId", value: matchID),
            
        ]
        var urlComponents = URLComponents(string: url)
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else {return  }
       
        asyncCall(urlString: (urlComponents?.string)!, method: method, parameters: nil, isGuestUser: true, anyDefaultToken: "108|HOAfqPcOxKaCS4dzAMgBvsN5tScJNhskT4w3iSeZee09c5cb")
    }
}
