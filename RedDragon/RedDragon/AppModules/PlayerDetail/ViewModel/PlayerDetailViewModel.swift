//
//  PlayerDetailViewModel.swift
//  RedDragon
//
//  Created by Ali on 11/13/23.
//

import Foundation

class PlayerDetailViewModel: APIServiceManager<PlayerDetailModel> {
    
    ///fetch player details data
    func fetchPlayerDetailAsyncCall(lang: String, slug: String) {
        let url     = URLConstants.playerDetail
        let method  = RequestType.post
        let parameters: [String: Any] = ["lang": lang, "slug": slug]
        asyncCall(urlString: url, method: method, parameters: parameters)
    }
}
