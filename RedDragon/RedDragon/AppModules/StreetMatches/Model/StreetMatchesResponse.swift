//
//  StreetMatchesResponse.swift
//  RedDragon
//
//  Created by Remya on 12/18/23.
//

import Foundation
struct StreetMatchesListResponse: Codable {
    let response: StreetMatchesListData?
    let error: StreetMatchesListData?
}

struct StreetMatchesListData: Codable {
    let code: Int?
    let messages: [String]?
    let data: [StreetMatch]?
}
