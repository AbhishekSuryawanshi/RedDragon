//
//  StreetPlayerPosition.swift
//  RedDragon
//
//  Created by Remya on 12/11/23.
//

import Foundation

// MARK: - StreetPlayerPosition
struct StreetPlayerPosition: Codable {
    let code, name, nameCN: String
    var count = 0

    enum CodingKeys: String, CodingKey {
        case code, name
        case nameCN = "name_cn"
    }
}
