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
    
    func eSportToGossipModel(eSportModel: ESports) -> Gossip {
        var gossipModel = Gossip()
        gossipModel.id = eSportModel.id
        gossipModel.title = eSportModel.articalTitle
        gossipModel.mediaSource = [URLConstants.eSportsBaseURL + eSportModel.articalThumbnailImage]
        return gossipModel
    }
}

class ESportsListVM: APIServiceManager<ESportsList> {
    init () {}
    static let shared = ESportsListVM()
    
    ///function to fetch e sports for gossips in news module
    func fetchESportsListAsyncCall() {
        let urlString   = URLConstants.eSportsList
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}

class ESportsDetailVM: APIServiceManager<ESportsDetail> {
    init () {}
    static let shared = ESportsDetailVM()
    
    ///function to fetch e sports detail for gossips in news module
    func fetchESportsDetailAsyncCall(id: Int) {
        let urlString   = URLConstants.eSportsDetail + "\(id)"
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}

class GossipVideoListVM: APIServiceManager<GossipVideoListResponse> {
    init () {}
    static let shared = GossipVideoListVM()
    var videoList: [GossipVideo] = []
    
    ///function to fetch videos for gossips in news module
    func fetchVideosAsyncCall() {
        let urlString   = URLConstants.videosList
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}

class GossipVideoVM: APIServiceManager<GossipVideoResponse> {
    init () {}
    static let shared = GossipVideoVM()
    
    ///function to fetch videos for gossips in news module
    func fetchVideoDetailAsyncCall(id: Int) {
        let urlString   = URLConstants.videosBaseURL + "\(id)"
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}
