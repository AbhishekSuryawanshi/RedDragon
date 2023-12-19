//
//  StreetTeamDetails.swift
//  RedDragon
//
//  Created by Remya on 12/8/23.
//

import Foundation

struct StreetTeamDetailsResponse: Codable {
    let response: StreetTeamDetailsData?
    let error: StreetTeamDetailsData?
}

struct StreetTeamDetailsData: Codable {
    let code: Int?
    let messages: [String]?
    let data: StreetTeamDetails?
}

// MARK: - Matches
struct StreetTeamMatches: Codable {
    let past: [StreetMatch]?
    let today, scheduled: [StreetMatch]?
}

// MARK: - StreetTeamDetails
struct StreetTeamDetails: Codable {
    let id: Int?
    let name, nameCN: String?
    let logoImgID: Int?
    let locationLong, locationLat: Double?
    let address, description, descriptionCN: String?
    let creatorUserID: Int?
    let createdAt, updatedAt: String?
    let players: [StreetMatchPlayer]?
    let matches: StreetTeamMatches?
    let creator: Creator?
    let logoImgURL: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case nameCN = "name_cn"
        case logoImgID = "logo_img_id"
        case locationLong = "location_long"
        case locationLat = "location_lat"
        case address, description
        case descriptionCN = "description_cn"
        case creatorUserID = "creator_user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case players, matches, creator
        case logoImgURL = "logo_img_url"
    }
}

// MARK: - Creator
struct Creator: Codable {
    let id: Int?
    let firstName, lastName, email, phoneNumber: String?
    let birthdate, type: String?
    let locationLong, locationLat: Double?
    let address, createdAt, updatedAt: String?
    let imgURL: String?
    let players: [StreetMatchPlayer]?
    let player: StreetMatchPlayer?

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
        case imgURL = "img_url"
        case players
        case player
    }
}

