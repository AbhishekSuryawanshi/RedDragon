//
//  StreetStadiumListResponse.swift
//  RedDragon
//
//  Created by Remya on 12/18/23.
//

import Foundation

struct StreetStradiumListingResponse: Codable {
    let response: StreetStradiumListingData?
    let error: StreetStradiumListingData?
}

struct StreetStradiumListingData: Codable {
    let code: Int?
    let messages: [String]?
    let data: [Stadium]?
}
