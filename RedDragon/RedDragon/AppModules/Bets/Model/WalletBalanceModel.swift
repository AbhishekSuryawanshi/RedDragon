//
//  WalletBalanceModel.swift
//  RedDragon
//
//  Created by Qoo on 21/11/2023.
//

import Foundation

struct WalletBalanceModel : Codable {
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
