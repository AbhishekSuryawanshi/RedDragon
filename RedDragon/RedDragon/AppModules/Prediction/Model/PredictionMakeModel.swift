//
//  PredictionMakeModel.swift
//  RedDragon
//
//  Created by Ali on 11/28/23.
//

import Foundation

// MARK: - PredictionMakeModel
struct PredictionMakeModel: Codable {
    var response: PredictionMakeResponse?
    var error: ErrorResponse?
}

// MARK: - Response
struct PredictionMakeResponse: Codable {
    var code: Int?
    var messages: [String]?
    var data: PredictionMakeData?
}

// MARK: - DataClass
struct PredictionMakeData: Codable {
    var message: String?
}

