//
//  GossipModel.swift
//  RedDragon
//
//  Created by Qasr01 on 28/11/2023.
//

import Foundation

struct GossipListResponse: Codable {
    let status: Int?
    let message: String?
    var data: GossipListData?
    var category: [String]? = []
    var source: [String]? = []
    
}

struct GossipResponse: Codable {
    let status: Int?
    let message: String?
    var data: Gossip?
}

struct GossipListData: Codable {
    var source: String?
    var category: String?
    var data: [Gossip]? = []
}

struct Gossip: Codable {
    var id: Int? = 0 //used for ESports to Gossip model conversion in GossipVC
    var title: String? = ""
    var slug: String? = ""
    var content: String? = ""
    var source: String? = ""
    var category: String? = ""
    var mediaSource: [String] = []
    
    enum CodingKeys: String, CodingKey {
        case title, slug, content, source, category
        case mediaSource = "media_source"
    }
    
    init () {}
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try (container.decodeIfPresent(String.self, forKey: .title) ?? "")
        slug = try (container.decodeIfPresent(String.self, forKey: .slug) ?? "")
        content = try (container.decodeIfPresent(String.self, forKey: .content) ?? "")
        source = try (container.decodeIfPresent(String.self, forKey: .source) ?? "")
        category = try (container.decodeIfPresent(String.self, forKey: .category) ?? "")
        mediaSource = try (container.decodeIfPresent([String].self, forKey: .mediaSource) ?? [])
    }
}

