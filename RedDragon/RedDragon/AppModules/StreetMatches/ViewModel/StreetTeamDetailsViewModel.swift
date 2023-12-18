//
//  StreetTeamDetailsViewModel.swift
//  RedDragon
//
//  Created by Remya on 12/8/23.
//

import Foundation
class StreetTeamDetailsViewModel: APIServiceManager<StreetTeamDetailsResponse> {
    
    //function to fetch match details
    func fetchStreetTeamDetailsAsyncCall(id:Int) {
        let urlString   = URLConstants.streetTeamDetails + "/\(id)/details"
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
    
}
