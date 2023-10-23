//
//  CustomErrors.swift
//  RedDragon
//
//  Created by QASR02 on 23/10/2023.
//

import Foundation

enum CustomErrors: Error {
    case invalidRequest
    case invalidJSON
    case unknown
    case noData
    case general(message: String)
    
    var description: String {
        switch self {
        case .invalidRequest:
            return ErrorMessage.somethingWentWrong.localized
        case .invalidJSON:
            return ErrorMessage.somethingWentWrong.localized
        case .unknown:
            return ErrorMessage.somethingWentWrong.localized
        case .noData:
            return ErrorMessage.somethingWentWrong.localized
        case .general(let message):
            return message
        }
    }
}
