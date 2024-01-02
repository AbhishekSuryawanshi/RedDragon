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
        let url     = URLConstants.baseURL + URLConstants.getMatchesList
        let method  = RequestType.get
        // Add the query parameters to the URL components
                let queryItems = [
                    URLQueryItem(name: "sportType", value: sportType),
                    URLQueryItem(name: "lang", value: lang),
                    URLQueryItem(name: "date", value: date),
                   
                    
                ]
                
                var urlComponents = URLComponents(string: url)
                urlComponents?.queryItems = queryItems
                
                guard let url = urlComponents?.url else {return  }
        
        asyncCall(urlString: (urlComponents?.string)!, method: method, parameters: nil)
    }

}

class MakePredictionViewModel: APIServiceManager<PredictionMakeModel> {
    
    ///fetch make prediction data
    func fetchMakePredictionAsyncCall(matchID: String, predictionTeam: String, comment: String, sportType: String) {
        let url     = URLConstants.baseURL + URLConstants.postMatchPrediction
        let method  = RequestType.post
        let parameters: [String: Any] = ["match_id": matchID, "predicted_team": predictionTeam, "comment": comment, "sportType": sportType]
        asyncCall(urlString: url, method: method, parameters: parameters)
    }
}

class PredictionDetailViewModel: APIServiceManager<PredictionMatchDetailModel> {
    
    ///fetch prediction matches data
    func fetchPredictionMatchesDetailAsyncCall(lang: String, matchID: String, sport: String) {
        let url     = URLConstants.baseURL + URLConstants.matchDetail + "/\(matchID)/\(sport)/details"
        let method  = RequestType.get
        // Add the query parameters to the URL components
                let queryItems = [
                   URLQueryItem(name: "lang", value: lang),
                    
                ]
                var urlComponents = URLComponents(string: url)
                urlComponents?.queryItems = queryItems
                
                guard let url = urlComponents?.url else {return  }
        
        asyncCall(urlString: (urlComponents?.string)!, method: method, parameters: nil)
    }
}

class PredictionsListUserViewModel: APIServiceManager<PredictionListModel> {
    
    ///fetch prediction matches data
    func fetchPredictionUserListAsyncCall(appUserID: String, sportType: String, date: String?) {
        let url     = URLConstants.baseURL + URLConstants.predictionList
        let method  = RequestType.get
        // Add the query parameters to the URL components
                let queryItems = [
                    URLQueryItem(name: "app_user_id", value: appUserID),
                    URLQueryItem(name: "sportType", value: sportType),
                    URLQueryItem(name: "dated", value: date)
                    
                ]
                
                var urlComponents = URLComponents(string: url)
                urlComponents?.queryItems = queryItems
                
                guard let url = urlComponents?.url else {return  }
        
        asyncCall(urlString: (urlComponents?.string)!, method: method, parameters: nil)
    }

}
