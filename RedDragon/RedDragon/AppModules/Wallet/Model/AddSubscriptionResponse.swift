//
//  AddSubscriptionResponse.swift
//  RedDragon
//
//  Created by Remya on 1/4/24.
//

import Foundation


// MARK: - AddSubscriptionResponse
struct AddSubscriptionResponse: Codable {
    let response: AddSubscriptionData?
    let error: AddSubscriptionData?
}

// MARK: - Response
struct AddSubscriptionData: Codable {
    let code: Int?
    let messages: [String]?
    let data: AddSubscription?
}

// MARK: - DataClass
struct AddSubscription: Codable {
    let coinCount: Int?
    let type, event: String?
    let userID: Int?
    let updatedAt, createdAt: String?
    let id, userwallet: Int?

    enum CodingKeys: String, CodingKey {
        case coinCount = "coin_count"
        case type, event
        case userID = "user_id"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id, userwallet
    }
}
