//
//  PredictionMatchDetailModel.swift
//  RedDragon
//
//  Created by Ali on 11/27/23.
//

import Foundation

// MARK: - PredictionMatchDetailModelElement
struct PredictionMatchDetailModelElement: Codable {
    var sport, sectionName, sectionSlug, leagueName: String?
    var leagueSlug, homeTeamName, homeTeamSlug: String?
    var homeTeamImage: String?
    var homeTeamIndicator1, homeTeamIndicator2, awayTeamName, awayTeamSlug: String?
    var awayTeamImage: String?
    var awayTeamIndicator1, awayTeamIndicator2, matchDatetime, matchState: String?
    var countDown, homeScore, home1StHalf, home2NdHalf: String?
    var awayScore, away1StHalf, away2NdHalf: String?
    var standings: [PredictionsStanding]?
    var about: String?
    var homeEvents, awayEvents: [PredictionEvent]?
    var medias: [PredictionsMedia]?
    var referee: PredictionsReferee?
    var location: [PredictionsLocation]?
    var homeLineup, awayLineup: PredictionsLineup?
    var statistics: [PredictionsStatistic]?
    var series: PredictionsSeries?
    var progress: [PredictionsProgress]?

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
        case standings, about
        case homeEvents = "home_events"
        case awayEvents = "away_events"
        case medias, referee, location
        case homeLineup = "home_lineup"
        case awayLineup = "away_lineup"
        case statistics, series, progress
    }
}

// MARK: - Event
struct PredictionEvent: Codable {
    var leagueName: String?
    var leagueLogo: String?
    var leagueSlug: String?
    var matches: [PredictionsMatch]?

    enum CodingKeys: String, CodingKey {
        case leagueName = "league_name"
        case leagueLogo = "league_logo"
        case leagueSlug = "league_slug"
        case matches
    }
}

// MARK: - Match
struct PredictionsMatch: Codable {
    var date, homeScore, awayScore, homeName: String?
    var awayName, slug, round: String?

    enum CodingKeys: String, CodingKey {
        case date
        case homeScore = "home_score"
        case awayScore = "away_score"
        case homeName = "home_name"
        case awayName = "away_name"
        case slug, round
    }
}

// MARK: - Lineup
struct PredictionsLineup: Codable {
    var lineupState1, lineupState2: String?
    var info, indicators: [PredictionsLocation]?
    var playerHeader: [[String]]?
    var playerMain, playerSubstitute: [[String]]?

    enum CodingKeys: String, CodingKey {
        case lineupState1 = "lineup_state_1"
        case lineupState2 = "lineup_state_2"
        case info, indicators
        case playerHeader = "player_header"
        case playerMain = "player_main"
        case playerSubstitute = "player_substitute"
    }
}

// MARK: - Location
struct PredictionsLocation: Codable {
    var key, value: String?
}

// MARK: - Media
struct PredictionsMedia: Codable {
    var preview: String?
    var video: String?
    var title, subtitle, date: String?
}

// MARK: - Progress
struct PredictionsProgress: Codable {
    var time, title: String?
    var data: [ProgressData]?
}

// MARK: - ProgressDatum
struct ProgressData: Codable {
    var time: String?
    var score: PredictionsScore?
    var mainPlayerName, mainPlayerSlug, subPlayerName, subPlayerSlug: String?
    var action: String?
    var isHome: Bool?

    enum CodingKeys: String, CodingKey {
        case time, score
        case mainPlayerName = "main_player_name"
        case mainPlayerSlug = "main_player_slug"
        case subPlayerName = "sub_player_name"
        case subPlayerSlug = "sub_player_slug"
        case action
        case isHome = "is_home"
    }
}

enum PredictionsScore: String, Codable {
    case empty = ""
    case the10 = "(1 - 0)"
}

// MARK: - Referee
struct PredictionsReferee: Codable {
    var name: String?
    var image: String?
    var indicators: [PredictionsLocation]?
}

// MARK: - Series
struct PredictionsSeries: Codable {
    var number: String?
    var data: [SeriesData]?
}

// MARK: - SeriesDatum
struct SeriesData: Codable {
    var header: String?
    var data: [String]?
}

// MARK: - Standing
struct PredictionsStanding: Codable {
    var name: String?
    var tableHeader: [String]?
    var tableData: [[String]]?

    enum CodingKeys: String, CodingKey {
        case name
        case tableHeader = "table_header"
        case tableData = "table_data"
    }
}

// MARK: - Statistic
struct PredictionsStatistic: Codable {
    var header: String?
    var data: [StatisticData]?
}

// MARK: - StatisticDatum
struct StatisticData: Codable {
    var key, homeValue, awayValue: String?
    var homePercent, awayPercent: Double?

    enum CodingKeys: String, CodingKey {
        case key
        case homeValue = "home_value"
        case awayValue = "away_value"
        case homePercent = "home_percent"
        case awayPercent = "away_percent"
    }
}

typealias PredictionMatchDetailModel = [PredictionMatchDetailModelElement]
