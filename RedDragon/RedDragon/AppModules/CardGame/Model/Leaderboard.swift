//
//  Leaderboard.swift
//  RedDragon
//
//  Created by QASR02 on 28/11/2023.
//

import Foundation

struct LeaderboardElement: Decodable {
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

typealias Leaderboard = [LeaderboardElement]
