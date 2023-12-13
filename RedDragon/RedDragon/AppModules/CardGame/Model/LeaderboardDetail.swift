//
//  LeaderboardDetail.swift
//  RedDragon
//
//  Created by QASR02 on 05/12/2023.
//

import Foundation

struct LeaderboardDetail: Decodable {
    let response: LeaderboardDetailResponse
}

// MARK: - Response
struct LeaderboardDetailResponse: Decodable {
    let code: Int
    let messages: [String]
    let data: DetailElement
}

struct DetailElement: Decodable {
    let id: Int
    let name, email: String
    let mobile, birthdate: String?
    let budget, score: Int
    let createdAt, updatedAt: String
    let players: [Player]
    let matchStats: MatchStats
    let imgURL: String

    enum CodingKeys: String, CodingKey {
        case id, name, email, mobile, birthdate, budget, score
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case players, matchStats
        case imgURL = "img_url"
    }
}

struct Player: Decodable {
    let playerID, userID: Int
    let name: String
    let position: String
    let marketValue, createdAt: String
    let imgURL: String

    enum CodingKeys: String, CodingKey {
        case playerID = "player_id"
        case userID = "user_id"
        case name, position
        case marketValue = "market_value"
        case createdAt = "created_at"
        case imgURL = "img_url"
    }
}

struct MatchStats: Decodable {
    let total, wins, loses: Int
}
