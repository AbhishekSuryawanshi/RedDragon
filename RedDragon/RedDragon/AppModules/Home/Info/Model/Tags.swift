//
//  Tags.swift
//  RedDragon
//
//  Created by QASR02 on 18/12/2023.
//

import Foundation

struct Tags: Decodable {
    let response: TagsResponse
}

struct TagsResponse: Decodable {
    let data: [TagsData]
    let code: Int
    let messages: [String]
}

struct TagsData: Decodable {
    let id: Int
    let tag, slug: String

    enum CodingKeys: String, CodingKey {
        case id, tag, slug
    }
}
