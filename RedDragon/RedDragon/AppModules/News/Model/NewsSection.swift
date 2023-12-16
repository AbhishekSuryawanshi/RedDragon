//
//  NewsSection.swift
//  RedDragon
//
//  Created by Abdullah on 15/12/2023.
//

import Foundation

enum NewsSection {
    case banner([NewsDetail]?)
    case latest([NewsDetail]?)
    case trending([NewsDetail]?)
    case video(NewsVideoModel)
    
    var data: [Codable] {
        switch self {
        case .banner(let model):
            guard let model = model else { return [] }
            let bannerData = model.shuffled().prefix(3)
            return Array(bannerData)

        case .latest(let model):
            guard let model = model else { return [] }
            let bannerData = model.shuffled().prefix(9)
            return Array(bannerData)
            
        case .trending(let model):
            guard let model = model else { return [] }
            
            return model
            
        case .video(let model):
            return model.list ?? []
        }
    }
    
    var numberOfRows: Int {
        switch self {
        case .banner(_), .latest(_), .video(_):
            return data.count > 1 ? 1 : 0
            
        case .trending(_):
            return data.count > 1 ? data.count : 0
        }
    }
    
    var title: String {
        switch self {
        case .banner(_):
            return ""

        case .latest(_):
            return "Trending"
            
        case .trending(_):
            return "Latest"
            
        case .video(_):
            return "Videos"
        }
    }
    
    var rowHeight: CGFloat {
        switch self {
        case .banner(_):
            return 163

        case .latest(_):
            return 252
            
        case .trending(_):
            return 210
            
        case .video(_):
            return 294

        }
    }
    
    var headerHeight: CGFloat {
        switch self {
        case .banner(_):
            return 0

        case .latest(_), .trending(_), .video(_):
            return 44
        }
    }
    
}
