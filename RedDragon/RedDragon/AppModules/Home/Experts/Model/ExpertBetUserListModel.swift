//
//  ExpertBetUserListModel.swift
//  RedDragon
//
//  Created by iOS Dev on 14/12/2023.
//

import Foundation

// MARK: - Bet and Prediction Users List
struct BetUserListModel: Codable {
    let response: BetUserList?
}

struct BetUserList: Codable {
    let data: [BetUser]?
}

struct BetUser: Codable {
    let appdata: AppData?
    let about: String?
    let profileImg: String?
  
    enum CodingKeys: String, CodingKey {
        case appdata
        case about
        case profileImg = "profile_img"
    }
}

struct AppData: Codable {
    let bet: Bet?
    let predict: Predict?
    
    enum CodingKeys: String, CodingKey {
        case bet
        case predict = "predict-match"
    }
}

struct Predict: Codable {
    let name: String?
    let predictStats: PredictStats?
    
    enum CodingKeys: String, CodingKey {
        case name
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
