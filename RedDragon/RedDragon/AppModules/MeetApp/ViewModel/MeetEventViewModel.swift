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
        asyncCall(urlString: urlString, method: method, parameters: nil, isGuestUser: true, anyDefaultToken: DefaultToken.guestUser)
    }
}

class MeetAllEventViewModel: APIServiceManager<MeetEventListModel> {
    ///function to fetch all event list
    func fetchMeetAllEventListAsyncCall() {
        let urlString   = URLConstants.meetAllEventList + "?pagination=false"
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil, isGuestUser: true, anyDefaultToken: DefaultToken.guestUser)
    }
}

class MeetMyUpcomingEventViewModel: APIServiceManager<MeetEventListModel> {
    ///function to fetch all event list
    func fetchMeetMyUpcomingEventListAsyncCall() {
        let urlString   = URLConstants.meetMyUpcomingEvent + "?pagination=false"
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil, isGuestUser: true, anyDefaultToken: DefaultToken.guestUser)
    }
}

class MeetMyPastEventViewModel: APIServiceManager<MeetEventListModel> {
    ///function to fetch all event list
    func fetchMeetMyPastEventListAsyncCall() {
        let urlString   = URLConstants.meetMyPastEvent + "?pagination=false"
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil, isGuestUser: true, anyDefaultToken: DefaultToken.guestUser)
    }
}

class MeetCreateEventVM: MultipartAPIServiceManager<MeetEventDetailModel> {
    ///function to upload image for a post for social module
    func postCreateEventAsyncCall(params: [String:Any], imageName: String, imageData: Data) {
        let urlString   = URLConstants.meetCreateEvent
        asyncCall(urlString: urlString, params: params,isGuestUser: true, anyDefaultToken: DefaultToken.guestUser, imageName: imageName, imageData: imageData, imageKey: "banner")
    }
}

class MeetEventDetailViewModel: APIServiceManager<MeetEventDetailModel> {
    ///function to fetch all event list
    func fetchMeetEventDetailAsyncCall(eventID: Int) {
        let urlString   = URLConstants.meetAllEventList + "?event_id=\(eventID)"
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil, isGuestUser: true, anyDefaultToken: DefaultToken.guestUser)
    }
}

class MeetJoinEventViewModel: APIServiceManager<MeetEventDetailModel> {
    ///function to fetch all event list
    func postJoinEventAsyncCall(eventID: Int) {
        let urlString   = URLConstants.meetJoinEvent
        let method      = RequestType.post
        let params      = JoinOrInviteMeetEventRequest(eventId: eventID).dictionary
        asyncCall(urlString: urlString, method: method, parameters: params, isGuestUser: true, anyDefaultToken: DefaultToken.guestUser)
    }
}
