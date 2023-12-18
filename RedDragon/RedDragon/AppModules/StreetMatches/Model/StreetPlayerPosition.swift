//
//  StreetPlayerPosition.swift
//  RedDragon
//
//  Created by Remya on 12/11/23.
//

import Foundation

struct StreetPlayerPositionResponse: Codable {
    let response: StreetPlayerPositionData?
    let error: StreetPlayerPositionData?
}

struct StreetPlayerPositionData: Codable {
    let code: Int?
    let messages: [String]?
    let data: [StreetPlayerPosition]?
}

// MARK: - StreetPlayerPosition
struct StreetPlayerPosition: Codable {
    let code, name, nameCN: String?
    var count = 0

    enum CodingKeys: String, CodingKey {
        case code, name
        case nameCN = "name_cn"
    }
}
