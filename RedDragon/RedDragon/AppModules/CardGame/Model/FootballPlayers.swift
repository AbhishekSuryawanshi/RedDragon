//
//  FootballPlayers.swift
//  RedDragon
//
//  Created by QASR02 on 20/11/2023.
//

import Foundation

struct FootballPlayers: Decodable {
    let status: Int
    let message: String
    let data: [PlayerData]
}

struct PlayerData: Decodable {
    let id, slug, name: String
    let photo: String
    let positionName: String
    let marketValue, rating: String
    let ability: [Ability]?

    enum CodingKeys: String, CodingKey {
        case id
        case slug, name
        case photo
        case positionName = "position_name"
        case marketValue = "market_value"
        case rating, ability
    }
}

struct Ability: Decodable {
    let name: String
    let value, fullAverage: Int

    enum CodingKeys: String, CodingKey {
        case name, value
        case fullAverage = "full_average"
    }
}
