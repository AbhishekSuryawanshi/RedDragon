//
//  UserModel.swift
//  RedDragon
//
//  Created by Qasr01 on 18/11/2023.
//

import Foundation

struct LoginResponse: Codable {
    let response: UserData?
    let error: UserData?
}

struct UserData: Codable {
    let code: Int?
    let messages: [String]?
    let data: User?
}

struct User: Codable {
    var id: Int = 0
    var name: String = ""
    var email: String = ""
    var username: String = ""
    var fullName: String = ""
    var phoneNumber: String = ""
    var profileImg: String = ""
    var createdAt: String = ""
    var updatedAt: String = ""
    var otpVerified: Int = 0
    var token: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id, email, username
        case name = "full_name"
        case phoneNumber = "phone_number"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case otpVerified = "otp_verified"
        case profileImg = "profile_img"
        case token = "access_token"
    }
    
    public init () {}
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        username = try container.decodeIfPresent(String.self, forKey: .username) ?? ""
        phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber) ?? ""
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt) ?? ""
        otpVerified = try container.decodeIfPresent(Int.self, forKey: .otpVerified) ?? 0
        profileImg = try container.decodeIfPresent(String.self, forKey: .profileImg) ?? ""
        token = try container.decodeIfPresent(String.self, forKey: .token) ?? ""
    }
}
