//
//  SubscriptionModel.swift
//  RedDragon
//
//  Created by Qasr01 on 22/12/2023.
//

import Foundation

struct SubscriptionResponse: Codable {
    let response: SubscriptionData?
    let error: SubscriptionData?
}

struct SubscriptionData: Codable {
    let code: Int?
    let messages: [String]?
    let data: [Subscription]?
}

struct Subscription: Codable {
    var id: Int = 0
    var userId: Int = 0
    var coinCount: Int = 0
    var event: String = ""
    var type: String = ""
    var updatedTime: String = ""
    var createdTime: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id, type, event
        case coinCount = "coin_count"
        case userId = "user_id"
        case updatedTime = "updated_at"
        case createdTime = "created_at"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try (container.decodeIfPresent(Int.self, forKey: .id) ?? 0)
        userId = try (container.decodeIfPresent(Int.self, forKey: .userId) ?? 0)
        coinCount = try (container.decodeIfPresent(Int.self, forKey: .coinCount) ?? 0)
        event = try (container.decodeIfPresent(String.self, forKey: .event) ?? "")
        type = try (container.decodeIfPresent(String.self, forKey: .type) ?? "")
        updatedTime = try (container.decodeIfPresent(String.self, forKey: .updatedTime) ?? "")
        createdTime = try (container.decodeIfPresent(String.self, forKey: .createdTime) ?? "")
    }
}
