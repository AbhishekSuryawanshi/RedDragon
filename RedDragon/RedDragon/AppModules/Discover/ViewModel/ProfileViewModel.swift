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
    
    func getProfileValue(type: SettingType) -> String {
        let user = UserDefaults.standard.user
        switch type {
        case .name:
            return user?.name ?? ""
        case .userName:
            return user?.username ?? ""
        case .email:
            return user?.email ?? ""
        case .phone:
            return user?.phoneNumber ?? ""
        case .password:
            return "Reset Password"
        case .gender:
            return user?.gender ?? ""
        case .dob:
            return (user?.dob.formatDate(inputFormat: dateFormat.yyyyMMdd, outputFormat: dateFormat.ddMMyyyy2)) ?? ""
        case .location:
            return user?.locationName ?? ""
        default:
            return ""
        }
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

class UpdatePasswordVM: APIServiceManager<BasicAPIResponse> {
    init () {}
    static let shared = UpdatePasswordVM()
    
    ///function for update password in profile
    func updatePasswordAsyncCall(parameters: [String: Any]) {
        asyncCall(urlString: URLConstants.updatepassword, method: .post, parameters: parameters)
    }
}
