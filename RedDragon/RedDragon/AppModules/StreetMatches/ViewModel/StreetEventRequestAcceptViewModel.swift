//
//  StreetEventRequestAcceptViewModel.swift
//  RedDragon
//
//  Created by Remya on 12/13/23.
//

import Foundation

class StreetEventRequestAcceptViewModel: APIServiceManager<StreetGeneralResponse> {
    
    //function to send event request
    func acceptEventRequestsAsyncCall(eventRequestID:Int) {
        let urlString   = URLConstants.eventRequests + "/\(eventRequestID)" +  "/accept"
        let method      = RequestType.post
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}

