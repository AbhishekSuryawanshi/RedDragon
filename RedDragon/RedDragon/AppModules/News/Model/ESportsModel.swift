//
//  ESportsModel.swift
//  RedDragon
//
//  Created by Qasr01 on 01/12/2023.
//

import Foundation

struct ESportsList: Codable {
    var newsList: [ESports] = []
    
    enum CodingKeys: String, CodingKey {
        case newsList = "NewsList"
    }
}

struct ESportsDetail: Codable {
    var specificeSportNews: [ESports] = []
}

struct ESports: Codable {
    var id: Int = 0
    var categoryType: String = ""
    var articalTitle: String = ""
    var articalPublishedDate: String = ""
    var articalThumbnailImage: String = ""
    var articalCoverImage: String? = ""
    var articalDescription: String? = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case categoryType = "category_type"
        case articalTitle = "artical_title"
        case articalPublishedDate = "artical_published_date"
        case articalThumbnailImage = "artical_thumbnail_image"
        case articalCoverImage = "artical_cover_image"
        case articalDescription = "artical_description"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try (container.decodeIfPresent(Int.self, forKey: .id) ?? 0)
        categoryType = try (container.decodeIfPresent(String.self, forKey: .categoryType) ?? "")
        articalTitle = try (container.decodeIfPresent(String.self, forKey: .articalTitle) ?? "")
        articalPublishedDate = try (container.decodeIfPresent(String.self, forKey: .articalPublishedDate) ?? "")
        articalThumbnailImage = try (container.decodeIfPresent(String.self, forKey: .articalThumbnailImage) ?? "")
        articalCoverImage = try (container.decodeIfPresent(String.self, forKey: .articalCoverImage) ?? "")
        articalDescription = try (container.decodeIfPresent(String.self, forKey: .articalDescription) ?? "")
    }
}
