//
//  StreetMatchDetails.swift
//  RedDragon
//
//  Created by Remya on 12/6/23.
//

import Foundation


struct StreetMatchDetailsResponse: Codable {
    let response: StreetMatchDetailsData?
    let error: StreetMatchDetailsData?
}

struct StreetMatchDetailsData: Codable {
    let code: Int?
    let messages: [String]?
    let data: StreetMatchDetails?
}

// MARK: - StreetMatchDetails
struct StreetMatchDetails: Codable {
    let id, homeTeamID, awayTeamID: Int?
    let locationLong, locationLat: Double?
    let address: String?
    let description, descriptionCN: String?
    let scheduleTime: String?
    let startTime: String?
    let status: String?
    let creatorUserID: Int?
    let createdAt, updatedAt: String?
    let homeTeam, awayTeam: StreetMatchTeam?

    enum CodingKeys: String, CodingKey {
        case id
        case homeTeamID = "home_team_id"
        case awayTeamID = "away_team_id"
        case locationLong = "location_long"
        case locationLat = "location_lat"
        case address, description
        case descriptionCN = "description_cn"
        case scheduleTime = "schedule_time"
        case startTime = "start_time"
        case status
        case creatorUserID = "creator_user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case homeTeam = "home_team"
        case awayTeam = "away_team"
    }
}

// MARK: - StreetMatchTeam
struct StreetMatchTeam: Codable {
    let id: Int?
    let name, nameCN: String?
    let logoImgID: Int?
    let locationLong, locationLat: Double?
    let address, description, descriptionCN: String?
    let creatorUserID: Int?
    let createdAt, updatedAt: String?
    let logoImgURL: String?
    let players: [StreetMatchPlayer]?

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
        case logoImgURL = "logo_img_url"
        case players
    }
}



// MARK: - StreetMatchPlayer
struct StreetMatchPlayer: Codable {
    let id, userID: Int?
    let createdAt, updatedAt: String?
    let dominateFoot: String?
    let weight, height: Int?
    let position: String?
    let yearActive: Int?
    let firstName, lastName, birthdate: String?
    let locationLong, locationLat: Double?
    let address: String?
    let description, descriptionCN: String?
    let creatorUserID, teamID, playerID: Int?
    let positionName, positionNameCN: String?
    let imgURL: String?
    var selected = false

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case dominateFoot = "dominate_foot"
        case weight, height, position
        case yearActive = "year_active"
        case firstName = "first_name"
        case lastName = "last_name"
        case birthdate
        case locationLong = "location_long"
        case locationLat = "location_lat"
        case address, description
        case descriptionCN = "description_cn"
        case creatorUserID = "creator_user_id"
        case teamID = "team_id"
        case playerID = "player_id"
        case positionName = "position_name"
        case positionNameCN = "position_name_cn"
        case imgURL = "img_url"
    }
}




