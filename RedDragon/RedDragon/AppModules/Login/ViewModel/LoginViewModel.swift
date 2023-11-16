//
//  LoginViewModel.swift
//  RedDragon
//
//  Created by Qasr01 on 16/11/2023.
//

import Foundation

class RegisterVM: APIServiceManager<BasicResponse> {
    init () {}
    static let shared = RegisterVM()
    
    ///function for user registration
    func registerAsyncCall(parameters: [String: Any]) {
        asyncCall(urlString: URLConstants.register, method: .post, parameters: parameters)
    }
}

class LoginVM: APIServiceManager<BasicResponse> {
    init () {}
    static let shared = LoginVM()
    
    ///function for user login
    func loginAsyncCall(parameters: [String: Any]) {
        asyncCall(urlString: URLConstants.login, method: .post, parameters: parameters)
    }
}

class UserVerifyVM: APIServiceManager<BasicResponse> {
    init () {}
    static let shared = UserVerifyVM()
    
    ///function for user login
    func loginAsyncCall(parameters: [String: Any]) {
        asyncCall(urlString: URLConstants.verifyOTP, method: .post, parameters: parameters)
    }
}
