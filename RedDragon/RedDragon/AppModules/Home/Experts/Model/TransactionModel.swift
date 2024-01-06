//
//  TransactionModel.swift
//  RedDragon
//
//  Created by iOS Dev on 05/01/2024.
//

import Foundation

struct TransactionModelResponse: Codable {
    let response: TransactionModel?
}

struct TransactionModel: Codable {
    let code: Int?
    let messages: [String]?
    let data: WalletData?
}

struct WalletData: Codable {
    let userwallet: Int?
}

