//
//  CreateMatchViewModel.swift
//  RedDragon
//
//  Created by Remya on 12/9/23.
//

import Foundation


class CreateMatchViewModel: APIServiceManager<StreetGeneralResponse> {
    
    //function to fetch home data
    func createMatchAsyncCall(parameters:[String:Any]) {
        let urlString   = URLConstants.streetMatches
        let method      = RequestType.post
        asyncCall(urlString: urlString, method: method, parameters: parameters)
    }
}
