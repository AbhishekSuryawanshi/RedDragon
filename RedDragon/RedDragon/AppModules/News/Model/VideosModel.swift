//
//  VideosModel.swift
//  RedDragon
//
//  Created by Qasr01 on 01/12/2023.
//

import Foundation

struct GossipVideoResponse: Codable {
    let code: Int?
    let msg: String?
    let time: Int?
    var data: [GossipVideo]? = []
}

struct GossipVideo: Codable {
    var id: Int = 0
    var title: String = ""
    var video: String = ""
    var createTime: Int = 0
    var cover, duration: String
    var browse: Int = 0
    var praiseStatus: Int = 0
    var praise: Int = 0
    var playAuth: String = ""
    var playURL: [String] = []
    
    enum CodingKeys: String, CodingKey {
        case id, title, video
        case createTime = "create_time"
        case cover, duration, browse
        case praiseStatus = "praise_status"
        case praise, playAuth
        case playURL = "playUrl"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try (container.decodeIfPresent(Int.self, forKey: .id) ?? 0)
        title = try (container.decodeIfPresent(String.self, forKey: .title) ?? "")
        video = try (container.decodeIfPresent(String.self, forKey: .video) ?? "")
        createTime = try (container.decodeIfPresent(Int.self, forKey: .createTime) ?? 0)
        cover = try (container.decodeIfPresent(String.self, forKey: .cover) ?? "")
        duration = try (container.decodeIfPresent(String.self, forKey: .duration) ?? "")
        browse = try (container.decodeIfPresent(Int.self, forKey: .browse) ?? 0)
        praiseStatus = try (container.decodeIfPresent(Int.self, forKey: .praiseStatus) ?? 0)
        praise = try (container.decodeIfPresent(Int.self, forKey: .praise) ?? 0)
        playAuth = try (container.decodeIfPresent(String.self, forKey: .playAuth) ?? "")
        playURL = try (container.decodeIfPresent([String].self, forKey: .playURL) ?? [])
    }
}

