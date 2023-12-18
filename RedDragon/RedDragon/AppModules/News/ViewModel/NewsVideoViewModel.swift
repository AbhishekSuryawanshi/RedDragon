//
//  NewsVideoViewModel.swift
//  RedDragon
//
//  Created by Abdullah on 13/12/2023.
//

import Foundation

final class NewsVideoViewModel: APIServiceManager<NewsVideoModel> {

    var model: NewsVideoModel!
    
    func fetchVideoListAsyncCall(page: Int = 1) {
        let lang = Utility.getCurrentLang() == "zh" ? "cn" : Utility.getCurrentLang()
        let urlString = URLConstants.newsBaseURL + URLConstants.videoList + lang + "/\(page)"
        let method = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
    
    func onVideoSuccess(response: NewsVideoModel?) {
        guard let model = response else { return }
        
        self.model = model
    }
    
}
