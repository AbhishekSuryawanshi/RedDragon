//
//  StreetProfileUser.swift
//  RedDragon
//
//  Created by Remya on 12/14/23.
//

import Foundation

// MARK: - StreetProfileUser
struct StreetProfileUser: Codable {
    let id: Int
    let firstName, lastName, email, phoneNumber: String
    let birthdate, type: String
    let locationLong, locationLat: Double
    let address, createdAt, updatedAt: String
    let player: StreetPlayer

    enum CodingKeys: String, CodingKey {
        case id
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
