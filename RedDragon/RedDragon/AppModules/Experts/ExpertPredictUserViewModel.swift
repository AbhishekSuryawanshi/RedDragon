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

class ExpertPredictionUserDetailViewModel: APIServiceManager<ExpertUserDetailModel> {
    
    ///function to fetch user detail
    func fetchExpertUserDetailAsyncCall(slug: String, userId: Int) {
        let urlString   = URLConstants.expertUserList + "?affiliated_app_slug=\(slug)&userId=\(userId)"
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}

class FollowUserViewModel: APIServiceManager<BasicAPIResponse> {
    
    ///function to post follow user
    func postFollowUser(userId: Int) {
        let urlString   = URLConstants.followUser + "\(userId)"
        let method      = RequestType.post
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}

class UnfollowUserViewModel: APIServiceManager<BasicAPIResponse> {
    
    ///function to post unfollow user
    func postUnfollowUser(userId: Int) {
        let urlString   = URLConstants.unfollowUser + "\(userId)"
        let method      = RequestType.post
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}

class TransactionViewModel: APIServiceManager<TransactionModelResponse> {
    
    ///function to post transaction
    func postDebitPredictionAmount(params: [String:Any]) {
        let urlString   = URLConstants.transaction
        let method      = RequestType.post
        asyncCall(urlString: urlString, method: method, parameters: params)
    }
}
