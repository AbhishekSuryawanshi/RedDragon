//
//  MyTeam.swift
//  RedDragon
//
//  Created by QASR02 on 27/11/2023.
//

import Foundation

struct MyTeam: Decodable {
    let response: MyTeamResponse
}

// MARK: - Response
struct MyTeamResponse: Decodable {
    let code: Int
    let messages: [String]
    let data: [MyTeamElement]
}


struct MyTeamElement: Codable {
    let playerID, userID: Int
    let name, position, marketValue, createdAt: String
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

//typealias MyTeam = [MyTeamElement]
