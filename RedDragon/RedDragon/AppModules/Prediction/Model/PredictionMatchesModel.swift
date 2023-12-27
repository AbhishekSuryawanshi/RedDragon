//
//  PredictionMatchesModel.swift
//  RedDragon
//
//  Created by Ali on 11/23/23.
//

import Foundation

// MARK: - PredictionMatchesModel
struct PredictionMatchesModel: Codable {
    var response: ResponsePrediction?
    var error: ErrorResponse?
}

// MARK: - Response
struct ResponsePrediction: Codable {
    var code: Int?
    var messages: [String]?
    var data: [PredictionData]?
}

// MARK: - Datum
struct PredictionData: Codable {
    var league, leagueSlug, section: String?
    var logo: String?
    var startDate, endDate: String?
    var matches: [PredictionMatch]?

    enum CodingKeys: String, CodingKey {
        case league
        case leagueSlug = "league_slug"
        case section, logo
        case startDate = "start_date"
        case endDate = "end_date"
        case matches
    }
}

// MARK: - Match
struct PredictionMatch: Codable {
    var slug, time: String?
    var matchState: String?
    var countDown, homeTeam, awayTeam, homeScore: String?
    var awayScore, homeFirstHalfScore, homeSecondHalfScore, awayFirstHalfScore: String?
    var awaySecondHalfScore: String?
    var odds1_Indicator: String?
    var odds1_Value: String?
    var odds2_Indicator: String?
    var odds2_Value: String?
    var odds3_Indicator: String?
    var odds3_Value: String?
    var lineup: Bool?
    var predStats: PredictionMatchStats?

    enum CodingKeys: String, CodingKey {
        case slug, time
        case matchState = "match_state"
        case countDown = "count_down"
        case homeTeam = "home_team"
        case awayTeam = "away_team"
        case homeScore = "home_score"
        case awayScore = "away_score"
        case homeFirstHalfScore = "home_first_half_score"
        case homeSecondHalfScore = "home_second_half_score"
        case awayFirstHalfScore = "away_first_half_score"
        case awaySecondHalfScore = "away_second_half_score"
        case odds1_Indicator = "odds_1_indicator"
        case odds1_Value = "odds_1_value"
        case odds2_Indicator = "odds_2_indicator"
        case odds2_Value = "odds_2_value"
        case odds3_Indicator = "odds_3_indicator"
        case odds3_Value = "odds_3_value"
        case lineup
        case predStats = "pred_stats"
    }
}

// MARK: - PredStats
struct PredictionMatchStats: Codable {
    var allCnt: Int?
    var winStats: WinStats?
    var drawCnt: Int?
}

// MARK: - WinStats
struct WinStats: Codable {
    var homeTeamCnt, awayTeamCnt: Int?

    enum CodingKeys: String, CodingKey {
        case homeTeamCnt = "home_team_cnt"
        case awayTeamCnt = "away_team_cnt"
    }
}




