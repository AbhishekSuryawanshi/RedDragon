//
//  User.swift
//  RedDragon
//
//  Created by Qasr01 on 30/10/2023.
//

import Foundation

struct User: Codable {
    var id: Int? = 0
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var image: String = ""
    var token: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id, email, token
        case firstName = "first_name"
        case lastName = "last_name"
        case image = "profile_image"
    }
    
    public init () {}
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try (container.decodeIfPresent(Int.self, forKey: .id) ?? 0)
        email = try (container.decodeIfPresent(String.self, forKey: .email) ?? "")
        firstName = try (container.decodeIfPresent(String.self, forKey: .firstName) ?? "")
        lastName = try (container.decodeIfPresent(String.self, forKey: .lastName) ?? "")
        image = try (container.decodeIfPresent(String.self, forKey: .image) ?? "")
        token = try (container.decodeIfPresent(String.self, forKey: .token) ?? "")
    }
}
