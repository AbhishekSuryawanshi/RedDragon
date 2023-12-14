//
//  NewsViewModel.swift
//  RedDragon
//
//  Created by Qasr01 on 25/11/2023.
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

final class NewsViewModel: APIServiceManager<NewsModel> {
    
    var model: NewsModel!
    var videoModel: NewsVideoModel!
    var section: [NewsSection] = []
    
    func fetchNewsDataAsyncCall(page: Int = 1, keyword: String = "/La Liga,World Cup,Transfer") {
        let lang = Utility.getCurrentLang() == "zh" ? "cn" : Utility.getCurrentLang()
        let urlString = URLConstants.newsBaseURL + URLConstants.newsList + lang + keyword + "?page=\(page)"
        let method = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
    
//    func fetchVideoListAsyncCall(page: Int = 1) {
//        let lang = Utility.getCurrentLang() == "zh" ? "cn" : Utility.getCurrentLang()
//        let urlString = URLConstants.newsBaseURL + URLConstants.videoList + lang + "/\(page)"
//        let method = RequestType.get
//        asyncCall(urlString: urlString, method: method, parameters: nil)
//    }
    
    func onNewsSuccess(response: NewsModel?) {
        guard let model = response else { return }
        if let currentPage = model.currentPage,
           let lastPage = model.lastPage,
           currentPage > 1 && currentPage < lastPage,
           let data = model.data {
            
            self.model.data?.append(contentsOf: data)
            let newData = self.model
            self.model = model
            self.model.data = newData?.data
            section.remove(at: 3)
            section.append(.trending(self.model.data))
        } else {
            self.model = model
            section = [.banner(model.data), .latest(model.data), .trending(model.data)]
        }
        
    }
    
    func onVideoSuccess(response: NewsVideoModel?) {
        guard let model = response else { return }
        
        self.videoModel = model
        section.insert(.video(model), at: 2)
    }

}
