//
//  HomePagePrediction.swift
//  RedDragon
//
//  Created by QASR02 on 18/12/2023.
//

import Foundation

struct HomePagePredictionData: Codable {
    let response: PredictionResponse
}

// MARK: - Response
struct PredictionResponse: Codable {
    let code: Int
    let messages: [String]
    let data: [PredictionDatum]
}

// MARK: - Datum
struct PredictionDatum: Codable {
    let league, leagueSlug, section: String
    let logo: String
    let startDate, endDate: String
    let matches: [HomePagePredictionMatch]

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
struct HomePagePredictionMatch: Codable {
    let slug, time: String
    let matchState: String
    let countDown, homeTeam, awayTeam, homeScore: String
    let awayScore, homeFirstHalfScore, homeSecondHalfScore, awayFirstHalfScore: String
    let awaySecondHalfScore: String
    let odds1_Indicator: String
    let odds1_Value: String
    let odds2_Indicator: String
    let odds2_Value: String
    let odds3_Indicator: String
    let odds3_Value: String
    let lineup: Bool
    let predStats: PredStats?

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
