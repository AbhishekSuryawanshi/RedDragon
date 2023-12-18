//
//  NewsModel.swift
//  RedDragon
//
//  Created by Qasr01 on 25/11/2023.
//

import Foundation

// MARK: - NewsModel
struct NewsModel: Codable {
    let currentPage: Int?
    var data: [NewsDetail]?
    let firstPageURL: String?
    let from, lastPage: Int?
    let lastPageURL, nextPageURL, path: String?
    let perPage: Int?
    let prevPageURL: String?
    let to, total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case firstPageURL = "first_page_url"
        case from
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case nextPageURL = "next_page_url"
        case path
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to, total
    }
}

// MARK: - NewsDetail
struct NewsDetail: Codable {
    let id, adminID, category, cover: Int?
    let browse, sort, status, translate: Int?
    let createTime, updateTime, title, description: String?
    let keywords: String?
    let path: String?
    let slugURL: String?
    let content: String?

    enum CodingKeys: String, CodingKey {
        case id
        case adminID = "admin_id"
        case category, cover, browse, sort, status, translate
        case createTime = "create_time"
        case updateTime = "update_time"
        case title, description, keywords, path, content
        case slugURL = "slug_url"
    }
}


