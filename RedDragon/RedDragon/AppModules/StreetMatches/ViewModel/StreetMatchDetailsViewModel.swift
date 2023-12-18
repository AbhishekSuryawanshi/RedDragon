//
//  StreetMatchDetailsViewModel.swift
//  RedDragon
//
//  Created by Remya on 12/6/23.
//

import Foundation

class StreetMatchDetailsViewModel: APIServiceManager<StreetMatchDetailsResponse> {
    
    //function to fetch match details
    func fetchStreetMatchDetailsAsyncCall(id:Int) {
        let urlString   = URLConstants.streetMatches + "/\(id)/details"
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}
