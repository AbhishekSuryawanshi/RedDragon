//
//  MatchDetail.swift
//  RedDragon
//
//  Created by QASR02 on 02/11/2023.
//

import Foundation

struct MatchDetail: Decodable {
    let status: Int
    let message: String
    let data: MatchDataClass
}

struct MatchDataClass: Decodable {
    let sport, sectionName, sectionSlug, leagueName: String
    let leagueSlug: String
    let homeTeamName, homeTeamSlug: String
    let homeTeamImage: String
    let homeTeamIndicator1, homeTeamIndicator2, awayTeamName, awayTeamSlug: String
    let awayTeamImage: String
    let awayTeamIndicator1, awayTeamIndicator2, matchDatetime, matchState: String
    let countDown, homeScore, home1StHalf, home2NdHalf: String
    let awayScore, away1StHalf, away2NdHalf: String
    let standings: [Standing]
    let about: String
    let homeEvents, awayEvents: [Event]
    let medias: [Media]
    let referee: Referee
    let location: [Location]
    let homeLineup, awayLineup: Lineup
    let statistics: [Statistic]
    let progress: [Progress]

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
        case statistics, progress
    }
}

struct Event: Decodable {
    let leagueName: String
    let leagueLogo: String
    let leagueSlug: String
    let matches: [Match]

    enum CodingKeys: String, CodingKey {
        case leagueName = "league_name"
        case leagueLogo = "league_logo"
        case leagueSlug = "league_slug"
        case matches
    }
}

struct Referee: Decodable {
    let name: String
    let image: String
    let indicators: [Location]
}

struct Location: Decodable {
    let key, value: String
}

struct Lineup: Decodable {
    let lineupState1, lineupState2: String
    let info, indicators: [Location]
    let playerHeader: [[String]]
    let playerMain, playerSubstitute: [[String]]

    enum CodingKeys: String, CodingKey {
        case lineupState1 = "lineup_state_1"
        case lineupState2 = "lineup_state_2"
        case info, indicators
        case playerHeader = "player_header"
        case playerMain = "player_main"
        case playerSubstitute = "player_substitute"
    }
}

struct Statistic: Decodable {
    let header: String
    let data: [StatisticDatum]
}

struct StatisticDatum: Decodable {
    let key, homeValue, awayValue: String
    let homePercent, awayPercent: Double

    enum CodingKeys: String, CodingKey {
        case key
        case homeValue = "home_value"
        case awayValue = "away_value"
        case homePercent = "home_percent"
        case awayPercent = "away_percent"
    }
}

struct Progress: Decodable {
    let time, title: String
    let data: [ProgressDatum]
}

// MARK: - ProgressDatum
struct ProgressDatum: Decodable {
    let time, score, mainPlayerName: String
    let mainPlayerSlug: String
    let subPlayerName, subPlayerSlug: String
    let action: String
    let isHome: Bool

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
