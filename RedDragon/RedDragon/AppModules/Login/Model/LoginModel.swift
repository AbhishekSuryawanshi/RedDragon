//
//  LoginModel.swift
//  RedDragon
//
//  Created by Qasr01 on 18/11/2023.
//

import Foundation

struct LoginResponse: Codable {
    let response: UserResponse?
    let error: ErrorResponse?
}

struct UserResponse: Codable {
    let code: Int?
    let message: [String]?
    let data: User?
}

struct ErrorResponse: Codable {
    let code: Int?
    let messages: [String]?
}
