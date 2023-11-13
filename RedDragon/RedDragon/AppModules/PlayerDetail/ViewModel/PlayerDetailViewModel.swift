//
//  PlayerDetailViewModel.swift
//  RedDragon
//
//  Created by Ali on 11/13/23.
//

import Foundation

class PlayerDetailsViewModel: APIServiceManager<PlayerDetailModel> {
    
    ///fetch player details data
    func fetchPlayerDetailAsyncCall(lang: String, slug: String, sports: String) {
        let url     = URLConstants.playerDetail
        let method  = RequestType.get
        let parameters: [String: Any] = ["lang": lang, "slug": slug]
        asyncCall(urlString: url, method: method, parameters: parameters)
    }
}
