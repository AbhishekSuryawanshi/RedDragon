//
//  NewsDetailViewModel.swift
//  RedDragon
//
//  Created by Abdullah on 09/12/2023.
//

import Foundation

final class NewsDetailViewModel: APIServiceManager<NewsDetail> {

    var model: NewsDetail
    
    init(model: NewsDetail) {
        self.model = model
    }
    
    func fetchDetailsAsyncCall(newsId: Int) {
        let lang = Utility.getCurrentLang() == "zh" ? "cn" : Utility.getCurrentLang()
        let urlString = URLConstants.newsBaseURL + URLConstants.newsDetail + lang + "/\(newsId)"
        let method = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
    
    func onSuccess(response: NewsDetail?) {
        guard let model = response else { return }
        
        self.model = model
    }
}
