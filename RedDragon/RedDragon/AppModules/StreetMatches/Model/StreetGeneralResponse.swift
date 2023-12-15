//
//  StreetGeneralResponse.swift
//  RedDragon
//
//  Created by Remya on 12/5/23.
//

import Foundation

struct StreetGeneralResponse: Codable {
    let response: StreetGeneralData?
    let error: StreetGeneralData?
}

struct StreetGeneralData: Codable {
    let code: Int?
    let messages: [String]?
}
    
