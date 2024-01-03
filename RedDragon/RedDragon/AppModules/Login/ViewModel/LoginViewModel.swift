//
//  LoginViewModel.swift
//  RedDragon
//
//  Created by Qasr01 on 16/11/2023.
//

import Foundation

class RegisterVM: APIServiceManager<LoginResponse> {
    init () {}
    static let shared = RegisterVM()
    
    ///function for user registration
    func registerAsyncCall(parameters: [String: Any]) {
        asyncCall(urlString: URLConstants.register, method: .post, parameters: parameters)
    }
}

class LoginVM: APIServiceManager<LoginResponse> {
    init () {}
    static let shared = LoginVM()
    
    ///function for user login
    func loginAsyncCall(parameters: [String: Any]) {
        asyncCall(urlString: URLConstants.login, method: .post, parameters: parameters)
    }
}

class UserVerifyVM: APIServiceManager<LoginResponse> {
    init () {}
    static let shared = UserVerifyVM()
    
    ///function for user verification after register
    func verificationAsyncCall(parameters: [String: Any]) {
        asyncCall(urlString: URLConstants.verifyOTP, method: .post, parameters: parameters)
    }
}

class ResendOtpVM: APIServiceManager<LoginResponse> {
    init () {}
    static let shared = ResendOtpVM()
    
    ///function for resend OTP
    func resendOtpAsyncCall() {
        asyncCall(urlString: URLConstants.resendOTP, method: .get, parameters: nil)
    }
}

class ForgotPasswordVM: APIServiceManager<LoginResponse> {
    init () {}
    static let shared = ForgotPasswordVM()
    
    ///function for forgot password
    func forgotPasswordAsyncCall(parameters: [String: Any]) {
        asyncCall(urlString: URLConstants.forgetPassword, method: .post, parameters: parameters)
    }
}

class ResetPasswordVM: APIServiceManager<LoginResponse> {
    init () {}
    static let shared = ResetPasswordVM()
    
    ///function for reset password
    func resetPasswordAsyncCall(parameters: [String: Any]) {
        asyncCall(urlString: URLConstants.resetpassword, method: .post, parameters: parameters)
    }
}

class LogoutVM: APIServiceManager<LoginResponse> {
    init () {}
    static let shared = LogoutVM()
    
    ///function for logout
    func logoutAsyncCall() {
        asyncCall(urlString: URLConstants.logout, method: .get, parameters: nil)
    }
}
