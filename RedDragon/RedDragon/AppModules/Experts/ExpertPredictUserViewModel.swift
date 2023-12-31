//
//  ExpertPredictUserViewModel.swift
//  RedDragon
//
//  Created by iOS Dev on 15/12/2023.
//

import Foundation

class ExpertPredictUserViewModel: APIServiceManager<ExpertUserListModel> {
    
    ///function to fetch user list
    func fetchExpertUserListAsyncCall(page: Int, slug: String, tag: String? = nil) {
        var urlString   = URLConstants.expertUserList + "?page=\(page)&app_slug=\(slug)"
        
        if let tag = tag {
            urlString += "&tag=\(tag)"
        }
        
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}

class ExpertBetUserViewModel: APIServiceManager<ExpertUserListModel> {
    
    ///function to fetch user list
    func fetchExpertUserListAsyncCall(page: Int, slug: String) {
        let urlString   = URLConstants.expertUserList + "?page=\(page)&app_slug=\(slug)"
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}
