//
//  PredictionMatchesModel.swift
//  RedDragon
//
//  Created by Ali on 11/23/23.
//

import Foundation

// MARK: - PredictionMatchesModelElement
struct PredictionMatchesModelElement: Codable {
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
    var matchState: MatchState?
    var countDown, homeTeam, awayTeam, homeScore: String?
    var awayScore, homeFirstHalfScore, homeSecondHalfScore, awayFirstHalfScore: String?
    var awaySecondHalfScore: String?
    var odds1_Indicator: OddsIndicator?
    var odds1_Value: String?
    var odds2_Indicator: OddsIndicator?
    var odds2_Value: String?
    var odds3_Indicator: OddsIndicator?
    var odds3_Value: String?
    var lineup: Bool?

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
    }
}

enum MatchState: String, Codable {
    case canceled = "canceled"
    case finished = "finished"
    case notstarted = "notstarted"
    case postponed = "postponed"
    case resultOnly = "result only"
}

enum OddsIndicator: String, Codable {
    case down = "down"
    case empty = ""
    case noChanges = "no-changes"
    case up = "up"
}

typealias PredictionMatchesModel = [PredictionMatchesModelElement]

