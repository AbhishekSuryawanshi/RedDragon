//
//  Bets.swift
//  RedDragon
//
//  Created by Qoo on 15/11/2023.
//

import Foundation

// MARK: - MatchListModel
struct MatchListModel: Codable {
    let status: Int?
    let message: String?
    let data: [MatchesList]?
}

// MARK: - MatchesList
struct MatchesList: Codable {
    
    let league: String
    let leagueSlug: String
    let section: String
    let logo: String
    let startDate: String
    let endDate: String
    let matches: [Matches]

}

struct Matches: Codable {

    let slug: String
    let time: String
    let matchState: String
    let countDown: String
    let homeTeam: String
    let awayTeam: String
    let homeScore: String
    let awayScore: String
    let homeFirstHalfScore: String
    let homeSecondHalfScore: String
    let awayFirstHalfScore: String
    let awaySecondHalfScore: String
    let odds1Indicator: String
    let odds1Value: String
    let odds2Indicator: String
    let odds2Value: String
    let odds3Indicator: String
    let odds3Value: String
    let lineup: Bool
    let betDetail: BetDetail

}

struct BetDetail: Codable {

    let totalBetAll: String
    let totalBetWin: String
    let totalBetLose: String
    let totalBetPending: String
    let amountBetAll: String
    let amountBetWin: String
    let amountBetLose: String
    let amountBetPending: String
    let betPlaced: Bool

}
