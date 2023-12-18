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
    var phoneNumber: String = ""
    var profileImg: String = ""
    var createdAt: String = ""
    var updatedAt: String = ""
    var otpVerified: Int = 0
    var token: String = ""
    var streetPlayerUpdated:Int = 0
    var appDataIDs = LocalAppUserID()
    var affAppData: AffAppData?
    
    enum CodingKeys: String, CodingKey {
        case id, email, username, appDataIDs, affAppData
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
        appDataIDs = try container.decodeIfPresent(LocalAppUserID.self, forKey: .appDataIDs) ?? LocalAppUserID()
        affAppData = try container.decodeIfPresent(AffAppData.self, forKey: .affAppData)
    }
}

struct AffAppData: Codable {
    var sportCard: SportCard?

    enum CodingKeys: String, CodingKey {
        case sportCard = "sport-card"
    }
}

struct SportCard: Codable {
    let budget: String
    let score: String
}

struct LocalAppUserID: Codable {
    var sportCardUserId: Int = 0
    var euro5LeagueUserId: Int = 0
    var predictMatchUserId: Int = 0
    var streetMatchUserId: Int = 0
    var vinderUserId: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case sportCardUserId = "sport-card_userid"
        case euro5LeagueUserId = "euro5-league_userid"
        case predictMatchUserId = "predict-match_userid"
        case streetMatchUserId = "street-match_userid"
        case vinderUserId = "vinder_userid"
    }
    
    public init () {}
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sportCardUserId = try container.decodeIfPresent(Int.self, forKey: .sportCardUserId) ?? 0
        euro5LeagueUserId = try container.decodeIfPresent(Int.self, forKey: .euro5LeagueUserId) ?? 0
        predictMatchUserId = try container.decodeIfPresent(Int.self, forKey: .predictMatchUserId) ?? 0
        streetMatchUserId = try container.decodeIfPresent(Int.self, forKey: .streetMatchUserId) ?? 0
        vinderUserId = try container.decodeIfPresent(Int.self, forKey: .vinderUserId) ?? 0
    }
}
