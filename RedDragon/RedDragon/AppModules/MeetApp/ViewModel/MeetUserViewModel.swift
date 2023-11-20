//
//  MeetUserViewModel.swift
//  RedDragon
//
//  Created by iOS Dev on 20/11/2023.
//

import Foundation

class MeetUserViewModel: APIServiceManager<MeetUserListModel> {
    
    ///function to fetch league data
    func fetchMeetUserListAsyncCall() {
        let urlString   = URLConstants.meetUserList + "?pagination=false"
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil, isGuestUser: true)
    }
    
}
