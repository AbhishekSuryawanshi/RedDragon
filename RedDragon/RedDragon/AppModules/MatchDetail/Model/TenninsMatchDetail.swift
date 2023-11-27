//
//  TenninsMatchDetail.swift
//  RedDragon
//
//  Created by Qoo on 27/11/2023.
//

import Foundation

struct TennisMatchDetail : Decodable{
    let status: Int
    let message: String
    let data: TennisDataClass
}

struct TennisDataClass: Decodable {
    let sport, sectionName, sectionSlug, leagueName: String?
    let leagueSlug, homeTeamName, homeTeamSlug: String?
    let homeTeamImage: String?
    let homeTeamIndicator1, homeTeamIndicator2, homeTeamIndicator3, awayTeamName: String?
    let awayTeamSlug: String?
    let awayTeamImage: String?
    let awayTeamIndicator1, awayTeamIndicator2, awayTeamIndicator3, matchDatetime: String?
    let matchState, countDown, homeScore, awayScore: String?
    let homeSet1, homeSet1_Superscript, homeSet2, homeSet2_Superscript: String?
    let homeSet3, homeSet3_Superscript, awaySet1, awaySet1_Superscript: String?
    let awaySet2, awaySet2_Superscript, awaySet3, awaySet3_Superscript: String?
    let about: String?
    let homeEvents, awayEvents: [Event]?
    let location: [Location]?
    
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
        case homeTeamIndicator3 = "home_team_indicator_3"
        case awayTeamName = "away_team_name"
        case awayTeamSlug = "away_team_slug"
        case awayTeamImage = "away_team_image"
        case awayTeamIndicator1 = "away_team_indicator_1"
        case awayTeamIndicator2 = "away_team_indicator_2"
        case awayTeamIndicator3 = "away_team_indicator_3"
        case matchDatetime = "match_datetime"
        case matchState = "match_state"
        case countDown = "count_down"
        case homeScore = "home_score"
        case awayScore = "away_score"
        case homeSet1 = "home_set_1"
        case homeSet1_Superscript = "home_set_1_superscript"
        case homeSet2 = "home_set_2"
        case homeSet2_Superscript = "home_set_2_superscript"
        case homeSet3 = "home_set_3"
        case homeSet3_Superscript = "home_set_3_superscript"
        case awaySet1 = "away_set_1"
        case awaySet1_Superscript = "away_set_1_superscript"
        case awaySet2 = "away_set_2"
        case awaySet2_Superscript = "away_set_2_superscript"
        case awaySet3 = "away_set_3"
        case awaySet3_Superscript = "away_set_3_superscript"
        case about
        case homeEvents = "home_events"
        case awayEvents = "away_events"
        case location
    }
    
}
