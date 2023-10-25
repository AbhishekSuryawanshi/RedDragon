//
//  DatabaseViewModel.swift
//  RedDragon
//
//  Created by QASR02 on 25/10/2023.
//

import Foundation

class DatabaseViewModel: APIServiceManager<LeagueDetailModel> {
    
    ///function to fetch league data
    func fetchLeagueDetailAsyncCall(lang: String, slug: String, season: String) {
        let urlString   = URLConstants.leagueDetail
        let method      = RequestType.get
        let parameters: [String: Any] = ["lang": lang, "slug": slug, "season": season]
        asyncCall(urlString: urlString, method: method, parameters: parameters)
    }
    
}
