//
//  NewsVideoModel.swift
//  RedDragon
//
//  Created by Abdullah on 12/12/2023.
//

import Foundation

// MARK: - NewsVideoModel
struct NewsVideoModel: Codable {
    let list: [VideoList]?
    let meta: Meta?
}

// MARK: - VideoList
struct VideoList: Codable {
    let id: Int?
    let cfHLSURL: String?
    let video, createTime: String?
    let thumbnailPath: String?
    let title: String?
    let path: String?
    let cfResp: String?

    enum CodingKeys: String, CodingKey {
        case id
        case cfHLSURL = "cf_hls_url"
        case video
        case createTime = "create_time"
        case thumbnailPath = "thumbnail_path"
        case title, path
        case cfResp = "cf_resp"
    }
}

// MARK: - Meta
struct Meta: Codable {
    let locale: String?
    let currentPage, lastPage, perPage, total: Int?
}
