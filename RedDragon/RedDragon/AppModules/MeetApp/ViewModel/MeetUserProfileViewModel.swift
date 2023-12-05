//
//  MeetUserProfileViewModel.swift
//  RedDragon
//
//  Created by iOS Dev on 29/11/2023.
//

import Foundation

class MeetUserSportsInterestViewModel: APIServiceManager<MeetUserSportsInterestModel> {
    
    ///function to get user sports interest
    func fetchSportsInterestAsyncCall() {
        let urlString   = URLConstants.meetSportsInterest
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil, isGuestUser: true, anyDefaultToken: DefaultToken.guestUser)
    }
}

