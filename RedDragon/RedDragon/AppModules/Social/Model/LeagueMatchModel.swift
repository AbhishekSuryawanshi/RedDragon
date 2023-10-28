//
//  LeagueMatchModel.swift
//  RedDragon
//
//  Created by Qasr01 on 28/10/2023.
//

import Foundation

struct SocialLeague: Codable {
    var id: String  = ""
    var cnName: String  = ""
    var cnAlias: String = ""
    var enName: String  = ""
    var enAlias: String = ""
    var logoURL: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case cnName  = "cn_name"
        case cnAlias = "cn_alias"
        case enName  = "en_name"
        case enAlias = "en_alias"
        case logoURL = "logo_url"
    }
    
    public init () {}
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id      = try (container.decodeIfPresent(String.self, forKey: .id) ?? "")
        cnName  = try (container.decodeIfPresent(String.self, forKey: .cnName) ?? "")
        cnAlias = try (container.decodeIfPresent(String.self, forKey: .cnAlias) ?? "")
        enName  = try (container.decodeIfPresent(String.self, forKey: .enName) ?? "")
        enAlias = try (container.decodeIfPresent(String.self, forKey: .enAlias) ?? "")
        logoURL = try (container.decodeIfPresent(String.self, forKey: .logoURL) ?? "")
    }
}

struct SocialTeam: Codable {
    var id: String = ""
    var cnName: String  = ""
    var cnAlias: String = ""
    var enName: String  = ""
    var enAlias: String = ""
    var coachEnName: String  = ""
    var coachCNName: String = ""
    var stadiumEnName: String  = ""
    var stadiumCNName: String = ""
    var cityEnName: String  = ""
    var cityCNName: String = ""
    var establishDate: String  = ""
    var logoURL: String = ""
    var marketValue: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case cnName  = "cn_name"
        case cnAlias = "cn_alias"
        case enName  = "en_name"
        case enAlias = "en_alias"
        case coachEnName = "coach_en_name"
        case coachCNName = "coach_cn_name"
        case stadiumCNName = "stadium_cn_name"
        case stadiumEnName = "stadium_en_name"
        case cityCNName = "city_cn_name"
        case cityEnName = "city_en_name"
        case establishDate = "establish_date"
        case logoURL = "logo_url"
        case marketValue = "market_value"
    }
    
    public init () {}
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id      = try (container.decodeIfPresent(String.self, forKey: .id) ?? "")
        cnName  = try (container.decodeIfPresent(String.self, forKey: .cnName) ?? "")
        cnAlias = try (container.decodeIfPresent(String.self, forKey: .cnAlias) ?? "")
        enName  = try (container.decodeIfPresent(String.self, forKey: .enName) ?? "")
        enAlias = try (container.decodeIfPresent(String.self, forKey: .enAlias) ?? "")
        coachEnName  = try (container.decodeIfPresent(String.self, forKey: .coachEnName) ?? "")
        coachCNName = try (container.decodeIfPresent(String.self, forKey: .coachCNName) ?? "")
        stadiumCNName  = try (container.decodeIfPresent(String.self, forKey: .stadiumCNName) ?? "")
        stadiumEnName = try (container.decodeIfPresent(String.self, forKey: .stadiumEnName) ?? "")
        cityCNName  = try (container.decodeIfPresent(String.self, forKey: .cityCNName) ?? "")
        cityEnName = try (container.decodeIfPresent(String.self, forKey: .cityEnName) ?? "")
        establishDate  = try (container.decodeIfPresent(String.self, forKey: .establishDate) ?? "")
        marketValue = try (container.decodeIfPresent(String.self, forKey: .marketValue) ?? "")
        logoURL = try (container.decodeIfPresent(String.self, forKey: .logoURL) ?? "")
    }
}

struct SocialMatchResponse: Codable {
    var data: [SocialMatch] = []
}

struct SocialMatch: Codable {
    var id: String = ""
    var homeTeam = SocialMatchTeam()
    var awayTeam = SocialMatchTeam()
    var homeScores: [Int] = []
    var awayScores: [Int] = []
    var matchUnixTime: Int = 0
    var matchDate = Date()
    
    enum CodingKeys: String, CodingKey {
        case id
        case awayTeam = "away_team"
        case homeTeam = "home_team"
        case homeScores = "home_scores"
        case awayScores = "away_scores"
        case matchUnixTime = "match_time"
    }
    
    public init () {}
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try (container.decodeIfPresent(String.self, forKey: .id) ?? "")
        awayTeam = try (container.decodeIfPresent(SocialMatchTeam.self, forKey: .awayTeam) ?? SocialMatchTeam())
        homeTeam = try (container.decodeIfPresent(SocialMatchTeam.self, forKey: .homeTeam) ?? SocialMatchTeam())
        homeScores = try (container.decodeIfPresent([Int].self, forKey: .homeScores) ?? [])
        awayScores = try (container.decodeIfPresent([Int].self, forKey: .awayScores) ?? [])
        matchUnixTime  = try (container.decodeIfPresent(Int.self, forKey: .matchUnixTime) ?? 0)
        matchDate = matchUnixTime.formatTimestampDate()
    }
}

struct SocialMatchTeam: Codable {
    var id: String  = ""
    var cnName: String  = ""
    var enName: String  = ""
    var logo: String  = ""
    
    enum CodingKeys: String, CodingKey {
        case id, logo
        case cnName = "name_cn"
        case enName = "name"
    }
    
    public init () {}
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try (container.decodeIfPresent(String.self, forKey: .id) ?? "")
        enName = try (container.decodeIfPresent(String.self, forKey: .enName) ?? "")
        cnName = try (container.decodeIfPresent(String.self, forKey: .cnName) ?? "")
        logo  = try (container.decodeIfPresent(String.self, forKey: .logo) ?? "")
    }
}
