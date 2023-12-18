//
//  StreetTeamListingResponse.swift
//  RedDragon
//
//  Created by Remya on 12/18/23.
//

import Foundation



struct StreetTeamListingResponse: Codable {
    let response: StreetTeamListingData?
    let error: StreetTeamListingData?
}

struct StreetTeamListingData: Codable {
    let code: Int?
    let messages: [String]?
    let data: [StreetTeam]?
}
