//
//  StreetEventRequestViewModel.swift
//  RedDragon
//
//  Created by Remya on 12/13/23.
//

import Foundation

class StreetEventRequestViewModel: APIServiceManager<[StreetEventRequest]> {
    
    //function to send event request
    func getEventRequestsAsyncCall(eventID:Int) {
        let urlString   = URLConstants.streetEvents + "/\(eventID)" +  "/request/list"
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}
