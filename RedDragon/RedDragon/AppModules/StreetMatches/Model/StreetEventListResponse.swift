//
//  StreetEventListResponse.swift
//  RedDragon
//
//  Created by Remya on 12/18/23.
//

import Foundation

struct StreetEventListResponse: Codable {
    let response: StreetEventListData?
    let error: StreetEventListData?
}

struct StreetEventListData: Codable {
    let code: Int?
    let messages: [String]?
    let data: [StreetEvent]?
}
