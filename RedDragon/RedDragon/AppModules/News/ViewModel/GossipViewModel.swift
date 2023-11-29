//
//  GossipViewModel.swift
//  RedDragon
//
//  Created by Qasr01 on 28/11/2023.
//

import Foundation

class GossipListVM: APIServiceManager<GossipListResponse> {
    init () {}
    static let shared = GossipListVM()
    
    var gossipsArray: [Gossip] = []
    
    ///function to fetch news list for gossips in news module
    func fetchNewsListAsyncCall(params: [String: Any]) {
        let urlString   = URLConstants.newsGossips
        let method      = RequestType.post
        asyncCall(urlString: urlString, method: method, parameters: params)
    }
}

class GossipVM: APIServiceManager<GossipResponse> {
    init () {}
    static let shared = GossipVM()
    
    ///function to fetch news detail for gossips in news module
    func fetchNewsDetailAsyncCall(params: [String: Any]) {
        let urlString   = URLConstants.newsGossips
        let method      = RequestType.post
        asyncCall(urlString: urlString, method: method, parameters: params)
    }
}
