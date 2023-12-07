//
//  ChatListModel.swift
//  Rezon
//
//  Created by cis on 27/04/20.
//  Copyright © 2020 cis. All rights reserved.
//

import Foundation

// MARK: - ChatListResponse
struct ChatListRequest: Codable {
    var userIDS: [Int]?

    enum CodingKeys: String, CodingKey {
        case userIDS = "user_ids"
    }
}


// MARK: - ChatListResponse
struct ChatListResponse: Codable {
    var msg: String?
    var status: Bool?
    var data: [ChatList]?
}

// MARK: - Datum
struct ChatList: Codable {
    var id: Int?
    var name: String?
    var userImage: String?
    var email: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name = "brand_name"
        case userImage = "user_image"
        case email
    }
}
