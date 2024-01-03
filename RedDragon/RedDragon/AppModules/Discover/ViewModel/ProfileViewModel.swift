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

class EditProfileVM: MultipartAPIServiceManager<LoginResponse> {
    static let shared = EditProfileVM()
    
    ///function to update profile
    func updateProfileAsyncCall(parameter: [String:Any]?, imageName: String = "", imageData: Data = Data()) {
        if let param = parameter {
            asyncCall(urlString: URLConstants.updateProfile, params: param)
        } else {
            asyncCall(urlString: URLConstants.updateProfile, params: nil, imageName: imageName, imageData: imageData, imageKey: "profile_img")
        }
    }
}

