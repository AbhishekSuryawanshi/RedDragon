//
//  ExpertBetUserListModel.swift
//  RedDragon
//
//  Created by iOS Dev on 14/12/2023.
//

import Foundation

// MARK: - Bet and Prediction Users List
struct ExpertUserListModel: Codable {
    let response: ExpertUserList?
}

struct ExpertUserList: Codable {
    let data: [ExpertUser]?
}

// MARK: - Bet and Prediction Users Detail
struct ExpertUserDetailModel: Codable {
    let response: ExpertUserDetail?
}

struct ExpertUserDetail: Codable {
    let data: ExpertUser?
}

struct ExpertUser: Codable {
    let id: Int?
    let name: String?
    var appdata: AppData?
    let about: String?
    let profileImg: String?
    var following: Bool?
    let tags: [String]?
    var wallet: Int?
    
    enum CodingKeys: String, CodingKey {
        case appdata, tags, wallet, name
        case about, following, id
        case profileImg = "profile_img"
    }
}

struct AppData: Codable {
    let bet: Bet?
    var predict: Predict?
    
    enum CodingKeys: String, CodingKey {
        case bet
        case predict = "predict-match"
    }
}

struct Predict: Codable {
    let name: String?
    let date: String
    var prediction: [ExpertPredictionMatch]
    let predictStats: PredictStats?
    
    enum CodingKeys: String, CodingKey {
        case name, prediction
        case date = "created_at"
        case predictStats = "pred_stats"
    }
}

struct PredictStats: Codable {
    let allCount: Int?
    let successCount: Int?
    let unsuccessCount: Int?
    let coins: Int?
    let successRate: Int?
    
    enum CodingKeys: String, CodingKey {
        case allCount = "allCnt"
        case successCount = "successCnt"
        case unsuccessCount = "unsuccessCnt"
        case coins
        case successRate = "success_rate"
    }
}

struct Bet: Codable {
    let name: String?
    let wallet: String?
    let winningAmount: String?
    let following: Bool?
    let betDetail: BetDetail?
    
    enum CodingKeys: String, CodingKey {
        case name = "full_name"
        case wallet, following
        case winningAmount = "wining_amount"
        case betDetail = "bet_detail"
    }
}

struct ExpertPredictionMatch: Codable {
    let predictionId: Int?
    let matchId: String?
    let isSuccess: Int?
    let match: PredictMatch?
    let sportType: String?
    var revealed: Bool?
    
    enum CodingKeys: String, CodingKey {
        case predictionId = "id"
        case isSuccess = "is_success"
        case matchId = "match_id"
        case match, sportType, revealed
    }
}

struct PredictMatch: Codable {
    let detail: PredictionMatchDetail?
}

