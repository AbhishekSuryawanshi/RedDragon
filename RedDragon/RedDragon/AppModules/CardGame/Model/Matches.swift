//
//  Matches.swift
//  RedDragon
//
//  Created by QASR02 on 05/12/2023.
//

import Foundation

struct YourMatch: Decodable {
    let id, userID: Int
    let opponentUserID: Int?
    let result: String
    let score: Int
    let createdAt, updatedAt: String
    let user: MatchUser
    let opponentUser: MatchUser?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case opponentUserID = "opponent_user_id"
        case result, score
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case user
        case opponentUser = "opponent_user"
    }
}

struct MatchUser: Decodable {
    let id: Int
    let name, email: String
    let mobile, birthdate: String?
    let budget, score: Int
    let createdAt, updatedAt: String
    let imgURL: String

    enum CodingKeys: String, CodingKey {
        case id, name, email, mobile, birthdate, budget, score
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case imgURL = "img_url"
    }
}

typealias YourMatches = [YourMatch]
