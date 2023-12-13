//
//  MeetUserViewModel.swift
//  RedDragon
//
//  Created by iOS Dev on 20/11/2023.
//

import Foundation

class MeetUserViewModel: APIServiceManager<MeetUserListModel> {
    
    ///function to fetch user list
    func fetchMeetUserListAsyncCall() {
        let urlString   = URLConstants.meetUserList + "?pagination=false"
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
                  //isGuestUser: true, anyDefaultToken: DefaultToken.guestUser)
    }
}

class MeetUserDetailViewModel: APIServiceManager<MeetUserDetailModel> {
    
    ///function to fetch user detail
    func fetchMeetUserDetailAsyncCall(userID: Int) {
        let urlString   = URLConstants.meetUserList + "?id=\(userID)"
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}

class MeetLikedUserViewModel: APIServiceManager<MeetLikedUserModel> {
    
    ///function to post like user
    func postLikeUserAsyncCall(parameters: [String: Any]) {
        let urlString   = URLConstants.meetLikedUser
        let method      = RequestType.post
        asyncCall(urlString: urlString, method: method, parameters: parameters)
    }
}

class MeetMyMatchUserViewModel: APIServiceManager<MeetUserListModel> {
    
    ///function to fetch my match user
    func fetchMyMatchUserAsyncCall() {
        let urlString   = URLConstants.meetMyMatchUser
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}

