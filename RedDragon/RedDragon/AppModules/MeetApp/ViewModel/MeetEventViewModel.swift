//
//  MeetEventViewModel.swift
//  RedDragon
//
//  Created by iOS Dev on 25/11/2023.
//

import Foundation

class MeetHotEventViewModel: APIServiceManager<MeetEventListModel> {
    
    ///function to fetch hot event list
    func fetchMeetHotEventListAsyncCall() {
        let urlString   = URLConstants.meetHotEventList + "?pagination=false"
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil, isGuestUser: true)
    }
    
}

class MeetAllEventViewModel: APIServiceManager<MeetEventListModel> {
    ///function to fetch all event list
    func fetchMeetAllEventListAsyncCall() {
        let urlString   = URLConstants.meetAllEventList + "?pagination=false"
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil, isGuestUser: true)
    }
}
