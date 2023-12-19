//
//  StreetProfileUser.swift
//  RedDragon
//
//  Created by Remya on 12/14/23.
//

import Foundation

struct StreetProfileUserResponse: Codable {
    let response: StreetProfileUserData?
    let error: StreetProfileUserData?
}

struct StreetProfileUserData: Codable {
    let code: Int?
    let messages: [String]?
    let data: StreetProfileUser?
}

// MARK: - StreetProfileUser
struct StreetProfileUser: Codable {
    let id: Int?
    let token:String?
    let firstName, lastName, email, phoneNumber: String?
    let birthdate, type: String?
    let locationLong, locationLat: Double?
    let address, createdAt, updatedAt: String?
    let player: StreetPlayer?

    enum CodingKeys: String, CodingKey {
        case id,token
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case phoneNumber = "phone_number"
        case birthdate, type
        case locationLong = "location_long"
        case locationLat = "location_lat"
        case address
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case player
    }
}
