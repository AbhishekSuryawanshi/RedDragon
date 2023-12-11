//
//  CreateTeamViewModel.swift
//  RedDragon
//
//  Created by Remya on 12/9/23.
//

import Foundation

class CreateTeamViewModel: APIServiceManager<StreetGeneralResponse> {
    
    //function to create team
    func createTeamAsyncCall(param:[String:Any]) {
        let urlString   = URLConstants.streetTeamDetails
        let method      = RequestType.post
        asyncCall(urlString: urlString, method: method, parameters: param)
    }
}
