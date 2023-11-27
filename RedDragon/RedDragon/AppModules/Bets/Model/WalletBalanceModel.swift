//
//  WalletBalanceModel.swift
//  RedDragon
//
//  Created by Qoo on 21/11/2023.
//

import Foundation

struct WalletBalanceModel : Codable {
    let response: Response?
    let error :  ErrorResponse?

    private enum CodingKeys: String, CodingKey {
        case response = "response"
        case error = "error"
    }
}

struct Response: Codable {

    let code: Int?
    let messages: [String]?
    let data: WalletBalance?

    private enum CodingKeys: String, CodingKey {
        case code = "code"
        case messages = "messages"
        case data = "data"
    }

}

struct WalletBalance : Codable {
    let status: Int?
    let message: String?
    let wallet: String?
    let data: [Transaction]?
    let totalRecord: String?

    private enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case wallet = "wallet"
        case data = "data"
        case totalRecord = "total_record"
    }
}


struct Transaction : Codable {

    let amount: String?
    let message: String?
    let created: String?

    private enum CodingKeys: String, CodingKey {
        case amount = "amount"
        case message = "message"
        case created = "created"
    }

}
