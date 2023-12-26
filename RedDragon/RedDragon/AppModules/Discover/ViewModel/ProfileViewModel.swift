//
//  ProfileViewModel.swift
//  RedDragon
//
//  Created by Qasr01 on 26/12/2023.
//

import Foundation

class ProfileVM: APIServiceManager<LoginResponse> {
    init () {}
    static let shared = ProfileVM()
    
    ///function to get profile
    func getProfileAsyncCall() {
        asyncCall(urlString: URLConstants.profile, method: .get, parameters: nil)
    }
}

class EditProfileVM: APIServiceManager<LoginResponse> {
    init () {}
    static let shared = EditProfileVM()
    
    ///function to get profile
    func updateProfileAsyncCall(parameter: [String:Any]) {
        asyncCall(urlString: URLConstants.profile, method: .post, parameters: parameter)
    }
}
