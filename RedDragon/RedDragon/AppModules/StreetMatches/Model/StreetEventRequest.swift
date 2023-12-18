//
//  StreetEventRequest.swift
//  RedDragon
//
//  Created by Remya on 12/13/23.
//

import Foundation

struct StreetEventRequestResponse: Codable {
    let response: StreetEventRequestData?
    let error: StreetEventRequestData?
}

struct StreetEventRequestData: Codable {
    let code: Int?
    let messages: [String]?
    let data: [StreetEventRequest]?
}

// MARK: - StreetEventRequest
struct StreetEventRequest: Codable {
    let id, creatorUserID, eventID: Int?
    let teamID: Int?
    let isAccepted: Int?
    let createdAt, updatedAt: String?
    let creator: Creator?
    let team: StreetTeam?

    enum CodingKeys: String, CodingKey {
        case id
        case creatorUserID = "creator_user_id"
        case eventID = "event_id"
        case teamID = "team_id"
        case isAccepted = "is_accepted"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case creator, team
    }
}
