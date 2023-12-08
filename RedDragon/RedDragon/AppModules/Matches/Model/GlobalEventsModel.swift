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
    var matchTime: String?
    var homeInfo: GlobalMatches?
    var awayInfo: GlobalMatches?
    var leagueInfo: GlobalMatches?
    var coverage: Coverage?
    var round: Round?
    var environment: Environment?
    var odds: Odds?
    
    enum CodingKeys: String, CodingKey {
        case matchTime = "match_timing"
        case homeInfo = "home_Info"
        case awayInfo = "away_Info"
        case leagueInfo = "league_Info"
        case coverage, round, environment, odds
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
    }
}

struct Coverage: Codable {
    var mlive: Int?
    var lineup: Int?
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


//{
//    "id": "6ypq3nh3zk0gmd7",
//    "season_id": "56ypq3nh9ovmd7o",
//    "competition_id": "kn54qllh28pqvy9",
//    "home_team_id": "4jwq2gh4no6m0ve",
//    "away_team_id": "3glrw7hydx0qdyj",
//    "status_id": 1,
//    "match_time": 1699950600,
//    "venue_id": "e4wyrn4h48oq86p",
//    "referee_id": "",
//    "neutral": 0,
//    "note": "",
//    "home_position": "11",
//    "away_position": "3",
//    "coverage": {
//        "mlive": 1,
//        "lineup": 0
//    },
//    "round": {
//        "stage_id": "ednm9whv895ryox",
//        "round_num": 4,
//        "group_num": 0
//    },
//    "environment": {
//        "weather": 5,
//        "pressure": "761mmHg",
//        "temperature": "22°C",
//        "wind": "2.0m/s",
//        "humidity": "47%"
//    },
//    "updated_at": 1699931422,
//    "match_timing": "2023-11-14 08:30:00",
//    "update_timing": "2023-11-14 03:10:22",
//    "home_Info": {
//        "en_name": "Shillong Lajong FC",
//        "cn_name": "西隆拉莊",
//        "en_short_name": "Shillong Lajong FC",
//        "logo": "https://img.thesports.com/football/team/714a6a87f097c2b3a1a9a46d34677fe6.png",
//        "home_score": 0,
//        "half_time_score": 0,
//        "red_cards": 0,
//        "corner_score": 0,
//        "overtime_score": 0,
//        "penalty_score": 0
//    },
//    "away_Info": {
//        "en_name": "Sreenidi Deccan",
//        "cn_name": "斯里尼迪德乾",
//        "en_short_name": "",
//        "logo": "https://img.thesports.com/football/team/ac0943dbb5e9a5b3efa8fe762e23330e.png",
//        "away_score": 0,
//        "half_time_score": 0,
//        "red_card": 0,
//        "yellow_cards": 0,
//        "corner_score": 0,
//        "overtime_score": 0,
//        "penalty_score": 0
//    },
//    "league_Info": {
//        "en_name": "Indian League Division 1",
//        "cn_name": "印度甲級聯賽",
//        "short_name": "IND Division 1",
//        "primary_color": "#0a4e7c",
//        "secondary_color": "#ea7628",
//        "logo": "https://img.thesports.com/football/competition/fd3a8019ad4593e751abe7c1fbaab83a.png"
//    },
//    "odds": {
//        "init": {
//            "asia": {
//                "home": 0.87,
//                "handicap": -0.75,
//                "away": 0.89
//            },
//            "euro": {
//                "home": 4.57,
//                "handicap": 3.75,
//                "away": 1.69
//            },
//            "bigSmall": {
//                "home": 0.81,
//                "handicap": 2.5,
//                "away": 0.94
//            }
//        }
//    }
//},
//}
