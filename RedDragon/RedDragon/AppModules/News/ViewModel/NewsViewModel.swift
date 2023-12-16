//
//  NewsViewModel.swift
//  RedDragon
//
//  Created by Qasr01 on 25/11/2023.
//

import Foundation

final class NewsViewModel: APIServiceManager<NewsModel> {
    
    var model: NewsModel!
    var videoModel: NewsVideoModel!
    var section: [NewsSection] = []
    var sportType: SportsType
    
    init(sportType: SportsType) {
        self.sportType = sportType
    }
    
    func fetchNewsDataAsyncCall(page: Int = 1, keyword: String = "/La Liga,World Cup,Transfer") {
        let lang = Utility.getCurrentLang() == "zh" ? "cn" : Utility.getCurrentLang()
        let urlString = URLConstants.newsBaseURL + URLConstants.newsList + lang + keyword + "?page=\(page)"
        let method = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
    
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
