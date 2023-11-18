//
//  ResponseModel.swift
//  RedDragon
//
//  Created by Qasr01 on 18/11/2023.
//

import Foundation

struct BasicAPIResponse: Codable {
    let response: BasicResponse?
    let error: BasicResponse?
}

struct BasicResponse: Codable {
    let code: Int?
    let messages: [String]?
}

