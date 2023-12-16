//
//  Banner.swift
//  RedDragon
//
//  Created by QASR02 on 16/12/2023.
//

import Foundation

struct Banners: Decodable {
    let data: BannerData
}

struct BannerData: Decodable {
    let top: [Top]
}

struct Top: Decodable {
    let id, title, coverPath, thumbnailPath: String
    let message, createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, title
        case coverPath = "cover_path"
        case thumbnailPath = "thumbnail_path"
        case message
        case createdAt = "created_at"
    }
}
