//
//  AnalysisModel.swift
//  RedDragon
//
//  Created by Ali on 11/29/23.
//

import Foundation

// MARK: - AnalysisModel
struct AnalysisModel: Codable {
    var response: AnalysisResponse?
    var error: ErrorResponse?
    
}
// MARK: - Response
struct AnalysisResponse: Codable {
    var code: Int?
    var messages: [String]?
    var data: [AnalysisData]?
}

// MARK: - AnalysisData
struct AnalysisData: Codable {
    var id, userID: Int?
    var matchID, winnerTeam, predictedTeam: String?
    var winnerScore, loserScore, isSuccess: Int?
    var createdAt, updatedAt: String?
    var comments: String?
    var predictedVia: String?
    var user: AnalysisUser?
    var loggedIn, isFollow: Bool?
    var reddragonUserID: Int?

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
        case comments
        case predictedVia = "predicted_via"
        case user
        case loggedIn = "logged_in"
        case isFollow = "is_follow"
        case reddragonUserID = "reddragon_user_id"
    }
}

// MARK: - AnalysisUser
struct AnalysisUser: Codable {
    var id: Int?
    var name, email: String?
    var emailVerifiedAt: JSONNull?
    var createdAt, updatedAt, signupVia: String?
    var imgURL: String?
    var predStats: AnalysisPredStats?

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

// MARK: - AnalysisPredStats
struct AnalysisPredStats: Codable {
    var allCnt, successCnt, unsuccessCnt, coins: Int?
    var successRate: Double?
    
    enum CodingKeys: String, CodingKey {
        case allCnt, successCnt, unsuccessCnt, coins
        case successRate = "success_rate"
    }
}

