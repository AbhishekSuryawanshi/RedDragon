//
//  Bets.swift
//  RedDragon
//
//  Created by Qoo on 15/11/2023.
//

import Foundation

// MARK: - MatchListModel
struct MatchListModel: Codable {
    let response: MatchResponse?
    let error :  ErrorResponse?

    private enum CodingKeys: String, CodingKey {
        case response = "response"
        case error = "error"
    }
}

struct MatchResponse: Codable {

    let code: Int?
    let messages: [String]?
    let data: [MatchesList]?

    private enum CodingKeys: String, CodingKey {
        case code = "code"
        case messages = "messages"
        case data = "data"
    }

}


// MARK: - MatchesList
struct MatchesList: Codable {
    
    let league: String?
    let leagueSlug: String?
    let section: String?
    let logo: String?
    let startDate: String?
    let endDate: String?
    let matches: [Matches]?

    private enum CodingKeys: String, CodingKey {
        case league = "league"
        case leagueSlug = "league_slug"
        case section = "section"
        case logo = "logo"
        case startDate = "start_date"
        case endDate = "end_date"
        case matches = "matches"
    }
}

struct Matches: Codable {

    let slug: String?
    let time: String?
    let matchState: String?
    let countDown: String?
    let homeTeam: String?
    let awayTeam: String?
    let homeScore: String?
    let awayScore: String?
    let homeFirstHalfScore: String?
    let homeSecondHalfScore: String?
    let awayFirstHalfScore: String?
    let awaySecondHalfScore: String?
    let odds1Indicator: String?
    let odds1Value: String?
    let odds2Indicator: String?
    let odds2Value: String?
    let odds3Indicator: String?
    let odds3Value: String?
    let lineup: Bool?
    let betDetail: BetDetail?

    private enum CodingKeys: String, CodingKey {
        case slug = "slug"
        case time = "time"
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
        case odds1Indicator = "odds_1_indicator"
        case odds1Value = "odds_1_value"
        case odds2Indicator = "odds_2_indicator"
        case odds2Value = "odds_2_value"
        case odds3Indicator = "odds_3_indicator"
        case odds3Value = "odds_3_value"
        case lineup = "lineup"
        case betDetail = "bet_detail"
    }
}

struct BetDetail: Codable {

    let totalBetAll: String?
    let totalBetWin: String?
    let totalBetLose: String?
    let totalBetPending: String?
    let amountBetAll: String?
    let amountBetWin: String?
    let amountBetLose: String?
    let amountBetPending: String?
    let betPlaced: Bool?
    
    
    private enum CodingKeys: String, CodingKey {
        case totalBetAll = "total_bet_all"
        case totalBetWin = "total_bet_win"
        case totalBetLose = "total_bet_lose"
        case totalBetPending = "total_bet_pending"
        case amountBetAll = "amount_bet_all"
        case amountBetWin = "amount_bet_win"
        case amountBetLose = "amount_bet_lose"
        case amountBetPending = "amount_bet_pending"
        case betPlaced = "bet_placed"
    }

}


struct BetListModel : Codable {
    
    let response: BetResponse?
    let error :  ErrorResponse?

    private enum CodingKeys: String, CodingKey {
        case response = "response"
        case error = "error"
    }
    
}

struct BetResponse: Codable {

    let code: Int?
    let messages: [String]?
    let data: BetList?

    private enum CodingKeys: String, CodingKey {
        case code = "code"
        case messages = "messages"
        case data = "data"
    }

}

struct BetList : Codable {
    
    let status: Int?
    let message: String?
    let bets: [BetItem]?
    let totalRecord: String?

    private enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case bets = "data"
        case totalRecord = "total_record"
    }
    
}


struct BetItem : Codable {
    let betId: String?
    let sport: String?
    let slug: String?
    let time: String?
    let matchState: String?
    let countDown: String?
    let homeTeam: String?
    let awayTeam: String?
    let homeScore: String?
    let awayScore: String?
    let homeFirstHalfScore: String?
    let homeSecondHalfScore: String?
    let awayFirstHalfScore: String?
    let awaySecondHalfScore: String?
    let odds1Indicator: String?
    let odds1Value: String?
    let odds2Indicator: String?
    let odds2Value: String?
    let odds3Indicator: String?
    let odds3Value: String?
    let betOddValue: String?
    let betOddIndex: String?
    let betAmount: String?
    let betStatus: String?
    let betDatetime: String?

    private enum CodingKeys: String, CodingKey {
        case betId = "bet_id"
        case sport = "sport"
        case slug = "slug"
        case time = "time"
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
        case odds1Indicator = "odds_1_indicator"
        case odds1Value = "odds_1_value"
        case odds2Indicator = "odds_2_indicator"
        case odds2Value = "odds_2_value"
        case odds3Indicator = "odds_3_indicator"
        case odds3Value = "odds_3_value"
        case betOddValue = "bet_odd_value"
        case betOddIndex = "bet_odd_index"
        case betAmount = "bet_amount"
        case betStatus = "bet_status"
        case betDatetime = "bet_datetime"
    }
}


struct BetSuccessModel : Codable{
    
    let response: BetSuccessResponse?
    let error :  ErrorResponse?

    private enum CodingKeys: String, CodingKey {
        case response = "response"
        case error = "error"
    }
}

struct BetSuccessResponse: Codable {

    let code: Int?
    let messages: [String]?
    let data: BetSuccess?

    private enum CodingKeys: String, CodingKey {
        case code = "code"
        case messages = "messages"
        case data = "data"
    }

}

struct BetSuccess : Codable{
    
    let status: Int?
    let message: String?
    
    private enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
    
}
    
}
