//
//  SendEventRequestsViewModel.swift
//  RedDragon
//
//  Created by Remya on 12/12/23.
//

import Foundation

class SendEventRequestsViewModel: APIServiceManager<StreetGeneralResponse> {
    
    //function to send event request
    func sendEventRequestAsyncCall(param:[String:Any]) {
        let urlString   = URLConstants.eventRequests
        let method      = RequestType.post
        asyncCall(urlString: urlString, method: method, parameters: param)
    }
}

