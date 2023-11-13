//
//  PlayerDetailModel.swift
//  RedDragon
//
//  Created by Ali on 11/13/23.
//

import Foundation

// MARK: - PlayerDetailModel
struct PlayerDetailModel: Codable {
    var status: Int?
    var message: String?
    var data: PlayerDetailData?
}

// MARK: - DataClass
struct PlayerDetailData: Codable {
    var playerID: String?
    var playerPhoto: String?
    var playerName, playerCountry: String?
    var teamPhoto: String?
    var teamName, teamSlug: String?
    var indicators, rating: [Indicator]?
    var statistics: [PlayerDetailStatistic]?
    var about: String?
    var events: [PlayerDetailEvent]?
    var medias: [PlayerDetailMedia]?

    enum CodingKeys: String, CodingKey {
        case playerID = "player_id"
        case playerPhoto = "player_photo"
        case playerName = "player_name"
        case playerCountry = "player_country"
        case teamPhoto = "team_photo"
        case teamName = "team_name"
        case teamSlug = "team_slug"
        case indicators, rating, statistics, about, events, medias
    }
}

// MARK: - Event
struct PlayerDetailEvent: Codable {
    var leagueName: String?
    var leagueLogo: String?
    var leagueSlug: String?
    var matches: [PlayerDetailMatch]?

    enum CodingKeys: String, CodingKey {
        case leagueName = "league_name"
        case leagueLogo = "league_logo"
        case leagueSlug = "league_slug"
        case matches
    }
}

// MARK: - Match
struct PlayerDetailMatch: Codable {
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

// MARK: - Indicator
struct Indicator: Codable {
    var key, value: String?
}

// MARK: - Media
struct PlayerDetailMedia: Codable {
    var preview: String?
    var video: String?
    var title, subtitle, date: String?
}

// MARK: - Statistic
struct PlayerDetailStatistic: Codable {
    var league: String?
    var data: [PlayerDetailStatisticData]?
}

// MARK: - Datum
struct PlayerDetailStatisticData: Codable {
    var section: String?
    var data: [Indicator]?
}

