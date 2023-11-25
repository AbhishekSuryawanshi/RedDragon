//
//  PredictionListModel.swift
//  RedDragon
//
//  Created by Ali on 11/25/23.
//

import Foundation

// MARK: - PredictionListModelElement
struct PredictionListModelElement: Codable {
    var id, userID: Int?
    var matchID, winnerTeam, predictedTeam: String?
    var winnerScore, loserScore, isSuccess: Int?
    var createdAt, updatedAt: String?
    var comments: JSONNull?
    var user: PredictionUser?
    var loggedIn: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case matchID = "match_id"
        case winnerTeam = "winner_team"
        case predictedTeam = "predicted_team"
        case winnerScore = "winner_score"
        case loserScore = "loser_score"
        case isSuccess = "is_success"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case comments, user
        case loggedIn = "logged_in"
    }
}

// MARK: - User
struct PredictionUser: Codable {
    var id: Int?
    var name, email: String?
    var emailVerifiedAt: JSONNull?
    var createdAt, updatedAt: String?
    var imgURL: JSONNull?
    var predStats: PredStats?

    enum CodingKeys: String, CodingKey {
        case id, name, email
        case emailVerifiedAt = "email_verified_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case imgURL = "img_url"
        case predStats = "pred_stats"
    }
}

// MARK: - PredStats
struct PredStats: Codable {
    var allCnt, successCnt, unsuccessCnt, coins: Int?
}

typealias PredictionListModel = [PredictionListModelElement]

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        
    }
}
