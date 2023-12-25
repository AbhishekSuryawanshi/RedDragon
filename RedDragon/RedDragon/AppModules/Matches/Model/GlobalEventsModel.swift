//
//  GlobalEventsModel.swift
//  VinderApp
//
//  Created by iOS Dev on 11/11/2023.
//

import Foundation

struct GlobalEventsModel: Codable {
    var matchList: [GlobalMatchList]?
    var hotMatches: [GlobalMatchList]?
    var hotLeagues: [HotLeagues]?
}

struct GlobalMatchList: Codable {
    var id: String?
    var matchTime: String?
    var homeInfo: GlobalMatches?
    var awayInfo: GlobalMatches?
    var leagueInfo: GlobalMatches?
    var coverage: Coverage?
    var homePosition: String?
    var awayPosition: String?
    var matchPosition: MatchPosition?
    var round: Round?
    var environment: Environment?
    var odds: Odds?
    
    enum CodingKeys: String, CodingKey {
        case id
        case matchTime = "match_timing"
        case homeInfo = "home_Info"
        case awayInfo = "away_Info"
        case leagueInfo = "league_Info"
        case matchPosition = "position"
        case coverage, round, environment, odds
        case homePosition = "home_position"
        case awayPosition = "away_position"
    }
}

struct HotLeagues: Codable {
    var id: String?
    var nameEnShort: String?
}

struct GlobalMatches: Codable {
    var name: String?
    var logo: String?
    var homeScore: Int?
    var awayScore: Int?
    var halfTimeScore: Int?
    var redCards: Int?
    var redCard: Int?
    var cornerScore: Int?
    var overtimeScore: Int?
    var penaltyScore: Int?
    var yellowCards: Int?
    var shortName: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "en_name"
        case homeScore = "home_score"
        case awayScore = "away_score"
        case logo
        case halfTimeScore = "half_time_score"
        case redCards = "red_cards"
        case redCard = "red_card"
        case cornerScore = "corner_score"
        case overtimeScore = "overtime_score"
        case penaltyScore = "penalty_score"
        case yellowCards = "yellow_cards"
        case shortName = "short_name"
    }
}

struct Coverage: Codable {
    var mlive: Int?
    var lineup: Int?
}

struct MatchPosition: Codable {
    var home: String?
    var away: String?
}

struct Round: Codable {
    var round: Int?
    var group: Int?
    
    enum CodingKeys: String, CodingKey {
        case round = "round_num"
        case group = "group_num"
    }
}

struct Environment: Codable {
    var weather: Int?
    var pressure: String?
    var temperature: String?
    var wind: String?
    var humidity: String?
}

struct Odds: Codable {
    var header: Init?
    enum CodingKeys: String, CodingKey {
        case header = "init"
    }
}

struct Init: Codable {
    var asia: Score?
    var euro: Score?
    var bigSmall: Score?
}

struct Score: Codable {
    var home: Double?
    var away: Double?
    var handicap: Double?
}

struct H2HMatchListModel: Codable {
    var history: History?
}

struct History: Codable {
    var homeMatchInfo: [MatchInfo]?
    var awayMatchInfo: [MatchInfo]?
   
    enum CodingKeys: String, CodingKey {
        case homeMatchInfo = "home_match_info"
        case awayMatchInfo = "away_match_info"
    }
}

struct MatchInfo: Codable {
    var homeName: String?
    var awayName: String?
    var homeScore: Int?
    var awayScore: Int?
    var homeHalfScore: Int?
    var awayHalfScore: Int?
    var homeOvertimeScore: Int?
    var awayOvertimeScore: Int?
    var homeRanking: String?
    var awayRanking: String?
    
    enum CodingKeys: String, CodingKey {
        case homeName = "home_en_name"
        case awayName = "away_en_name"
        case homeScore = "home_team_score"
        case awayScore = "away_team_score"
        case homeHalfScore = "home_team_half_time_score"
        case awayHalfScore = "away_team_half_time_score"
        case homeOvertimeScore = "home_team_overTime_score"
        case awayOvertimeScore = "away_team_overTime_score"
        case homeRanking = "home_league_ranking"
        case awayRanking = "away_league_ranking"
    }
}

