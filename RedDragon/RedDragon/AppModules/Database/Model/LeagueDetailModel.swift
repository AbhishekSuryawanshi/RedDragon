//
//  LeagueDetailModel.swift
//  RedDragon
//
//  Created by QASR02 on 25/10/2023.
//

import Foundation

struct LeagueDetailModel: Decodable {
    let status: Int
    let message: String
    let data: DataClass
}

struct DataClass: Decodable {
    let slug: String
    let photo: String
    let name, id, hostCountry, season: String
    let seasonOptions: [String]
    let seasonStartDate, seasonEndDate: String
    let tournamentPerformance: [TournamentPerformance]
    let seasonPerformance: [SeasonPerformance]
    let champions: [Champion]
    let standings: [Standing]
    let about: String
    let events: [EventData]
    let medias: [Media]
    //let cups: [JSONAny]

    enum CodingKeys: String, CodingKey {
        case slug, photo, name, id
        case hostCountry = "host_country"
        case season
        case seasonOptions = "season_options"
        case seasonStartDate = "season_start_date"
        case seasonEndDate = "season_end_date"
        case tournamentPerformance = "tournament_performance"
        case seasonPerformance = "season_performance"
        case champions, standings, about, events, medias
    }
}

struct TournamentPerformance: Decodable {
    let key, value: String
}

struct SeasonPerformance: Decodable {
    let name: String
    let header: [Header]
    let subheader: [Subheader]
    let data: [[String]]
}

enum Header: String, Decodable {
    case awayAverage = "Away (Average)"
    case homeAverage = "Home (Average)"
    case overallAverage = "Overall (Average)"
    case teams = "Teams"
}

enum Subheader: String, Decodable {
    case average = "Average"
    case games = "Games"
    case missed = "Missed"
    case o25 = "O 2.5"
    case result = "Result"
    case scored = "Scored"
    case subheaderO25 = "O 2.5 (%)"
    case subheaderU25 = "U 2.5 (%)"
    case teamLogo = "team_logo"
    case teamName = "team_name"
    case teamSlug = "team_slug"
    case total = "Total"
    case u25 = "U 2.5"
}

struct Champion: Decodable {
    let slug: String
    let logo: String
    let teamName, title: String

    enum CodingKeys: String, CodingKey {
        case slug, logo
        case teamName = "team_name"
        case title
    }
}

struct Standing: Decodable {
    let name: String
    let tableHeader: [String]
    let tableData: [[String]]

    enum CodingKeys: String, CodingKey {
        case name
        case tableHeader = "table_header"
        case tableData = "table_data"
    }
}

struct EventData: Decodable {
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

struct Match: Decodable {
    let date, homeScore, awayScore, homeName: String
    let awayName, slug: String
    let round: String

    enum CodingKeys: String, CodingKey {
        case date
        case homeScore = "home_score"
        case awayScore = "away_score"
        case homeName = "home_name"
        case awayName = "away_name"
        case slug, round
    }
}

struct Media: Decodable {
    let preview: String
    let video: String
    let title, subtitle, date: String
}
