//
//  StreetHome.swift
//  RedDragon
//
//  Created by Remya on 11/24/23.
//

import Foundation


struct StreetMatchHomeResponse: Codable {
    let response: StreetMatchHomeData?
    let error: StreetMatchHomeData?
}

struct StreetMatchHomeData: Codable {
    let code: Int?
    let messages: [String]?
    let data: StreetMatchHome?
}


// MARK: - StreetMatchHome
struct StreetMatchHome: Codable {
    let matches: [StreetMatch]?
    let events: [StreetEvent]?
    let teams: [StreetTeam]?
    let stadiums: [Stadium]?
}

// MARK: - Event
struct StreetEvent: Codable {
    let id: Int
    let type: String?
    let locationLong, locationLat: Double?
    let address: String?
    let imgID: Int?
    let description, descriptionCN: String?
    let creatorUserID: Int?
    let teamID: Int?
    let scheduleTime: String?
    let isClosed: Int?
    let createdAt, updatedAt: String?
    let teamName, teamNameCN, teamAddress: String?
    let eventImgURL: String?
    let teamLogoURL: String?
    let creatorName: String?
    let creatorImgURL: String?
    let positions: [StreetPosition]?
    let creatorUser: CreatorUser?

    enum CodingKeys: String, CodingKey {
        case id, type
        case locationLong = "location_long"
        case locationLat = "location_lat"
        case address
        case imgID = "img_id"
        case description
        case descriptionCN = "description_cn"
        case creatorUserID = "creator_user_id"
        case teamID = "team_id"
        case scheduleTime = "schedule_time"
        case isClosed = "is_closed"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case teamName = "team_name"
        case teamNameCN = "team_name_cn"
        case teamAddress = "team_address"
        case eventImgURL = "event_img_url"
        case teamLogoURL = "team_logo_url"
        case creatorName = "creator_name"
        case creatorImgURL = "creator_img_url"
        case positions
        case creatorUser = "creator_user"
    }
}

// MARK: - CreatorUser
struct CreatorUser: Codable {
    let id: Int?
    let firstName, lastName, email, phoneNumber: String?
    let birthdate:String?
    let type: String?
    let locationLong, locationLat: Double?
    let address, createdAt, updatedAt: String?
    let imgURL: String?
    let players: [StreetPlayer]?

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
    }
}

// MARK: - Player
struct StreetPlayer: Codable {
    let id, userID: Int?
    let createdAt, updatedAt, dominateFoot: String?
    let weight, height: Int?
    let position: String?
    let yearActive: Int?
    let firstName, lastName, birthdate: String?
    let locationLong, locationLat: Double?
    let address, description, descriptionCN: String?
    let creatorUserID: Int?
    let positionName, positionNameCN: String?
    let imgURL: String?

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
        case positionName = "position_name"
        case positionNameCN = "position_name_cn"
        case imgURL = "img_url"
    }
}

// MARK: - Position
struct StreetPosition: Codable {
    let position, positionName, positionNameCN, count: String?

    enum CodingKeys: String, CodingKey {
        case position
        case positionName = "position_name"
        case positionNameCN = "position_name_cn"
        case count
    }
}

// MARK: - Match
struct StreetMatch: Codable {
    let id, homeTeamID, awayTeamID: Int?
    let locationLong, locationLat: Double?
    let address: String?
    let description, descriptionCN: String?
    let scheduleTime: String?
    let startTime: String?
    let status: String?
    let creatorUserID: Int?
    let createdAt, updatedAt: String?
    let homeTeam, awayTeam: StreetTeam?

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

// MARK: - Team
struct StreetTeam: Codable {
    let id: Int?
    let name, nameCN: String?
    let logoImgID: Int?
    let locationLong, locationLat: Double?
    let address, description, descriptionCN: String?
    let creatorUserID: Int?
    let createdAt, updatedAt: String?
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
        case logoImgURL = "logo_img_url"
    }
}

// MARK: - Stadium
struct Stadium: Codable {
    let id: Int?
    let name, nameCN, description, descriptionCN: String?
    let locationLong, locationLat: Double?
    let address, timings: String?
    let ownerUserID: Int?
    let availableSports, amenities, createdAt, updatedAt: String?
    let imgsUrls: [String]?
    let owner: CreatorUser?

    enum CodingKeys: String, CodingKey {
        case id, name
        case nameCN = "name_cn"
        case description
        case descriptionCN = "description_cn"
        case locationLong = "location_long"
        case locationLat = "location_lat"
        case address, timings
        case ownerUserID = "owner_user_id"
        case availableSports = "available_sports"
        case amenities
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case imgsUrls = "imgs_urls"
        case owner
    }
}

