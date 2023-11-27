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
