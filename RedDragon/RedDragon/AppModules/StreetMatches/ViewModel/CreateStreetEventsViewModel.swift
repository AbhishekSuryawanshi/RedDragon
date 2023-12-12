//
//  CreateStreetEventsViewModel.swift
//  RedDragon
//
//  Created by Remya on 12/11/23.
//

import Foundation


class CreateStreetEventsViewModel: APIServiceManager<StreetGeneralResponse> {
    
    //function to create street event
    func createStreetEventAsyncCall(parameters:[String:Any]) {
        let urlString   = URLConstants.streetEvents
        let method      = RequestType.post
        asyncCall(urlString: urlString, method: method, parameters: parameters)
    }
}
