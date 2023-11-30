//
//  PredictionListModel.swift
//  RedDragon
//
//  Created by Ali on 11/25/23.
//

import Foundation

// MARK: - PredictionListModel
struct PredictionListModel: Codable {
    var data: [PredictionsData]?
}

struct PredictionsData: Codable {
    var id, userID: Int?
    var matchID, winnerTeam, predictedTeam: String?
    var winnerScore, loserScore, isSuccess: Int?
    var createdAt, updatedAt: String?
    var comments: String?
    var predictedVia: String?
    var sportType: String?
    var user: PredictionUser?
    var loggedIn: Bool?
    var matchDetail: PredictionMatchDetail

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
        case comments, user, sportType
        case predictedVia = "predicted_via"
        case loggedIn = "logged_in"
        case matchDetail = "match_detail"
    }
}

// MARK: - MatchDetail
struct PredictionMatchDetail: Codable {
    var sport, sectionName, sectionSlug, leagueName: String?
    var leagueSlug, homeTeamName, homeTeamSlug: String?
    var homeTeamImage: String?
    var homeTeamIndicator1, homeTeamIndicator2, awayTeamName, awayTeamSlug: String?
    var awayTeamImage: String?
    var awayTeamIndicator1, awayTeamIndicator2, matchDatetime, matchState: String?
    var countDown, homeScore, home1StHalf, home2NdHalf: String?
    var awayScore, away1StHalf, away2NdHalf: String?

    enum CodingKeys: String, CodingKey {
        case sport
        case sectionName = "section_name"
        case sectionSlug = "section_slug"
        case leagueName = "league_name"
        case leagueSlug = "league_slug"
        case homeTeamName = "home_team_name"
        case homeTeamSlug = "home_team_slug"
        case homeTeamImage = "home_team_image"
        case homeTeamIndicator1 = "home_team_indicator_1"
        case homeTeamIndicator2 = "home_team_indicator_2"
        case awayTeamName = "away_team_name"
        case awayTeamSlug = "away_team_slug"
        case awayTeamImage = "away_team_image"
        case awayTeamIndicator1 = "away_team_indicator_1"
        case awayTeamIndicator2 = "away_team_indicator_2"
        case matchDatetime = "match_datetime"
        case matchState = "match_state"
        case countDown = "count_down"
        case homeScore = "home_score"
        case home1StHalf = "home_1st_half"
        case home2NdHalf = "home_2nd_half"
        case awayScore = "away_score"
        case away1StHalf = "away_1st_half"
        case away2NdHalf = "away_2nd_half"
    }
}

// MARK: - PredictionUser
struct PredictionUser: Codable {
    var id: Int?
    var name, email: String?
    var emailVerifiedAt: JSONNull?
    var createdAt, updatedAt, signupVia: String?
    var imgURL: JSONNull?
    var predStats: PredStats?

    enum CodingKeys: String, CodingKey {
        case id, name, email
        case emailVerifiedAt = "email_verified_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case signupVia = "signup_via"
        case imgURL = "img_url"
        case predStats = "pred_stats"
    }
}

// MARK: - PredStats
struct PredStats: Codable {
    var allCnt, successCnt, unsuccessCnt, coins: Int?
}

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
