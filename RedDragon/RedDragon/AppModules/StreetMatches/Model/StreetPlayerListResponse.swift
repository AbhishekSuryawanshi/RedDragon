//
//  StreetPlayerListResponse.swift
//  RedDragon
//
//  Created by Remya on 12/18/23.
//

import Foundation

struct StreetPlayersListResponse: Codable {
    let response: StreetPlayersListData?
    let error: StreetPlayersListData?
}

struct StreetPlayersListData: Codable {
    let code: Int?
    let messages: [String]?
    let data: [StreetMatchPlayer]?
}
