//
//  SocialPostViewModel.swift
//  RedDragon
//
//  Created by Qasr01 on 01/11/2023.
//

import Foundation

class SocialPostListVM: APIServiceManager<SocialPostListResponse> {
    init () {}
    static let shared = SocialPostListVM()
    
    ///function to fetch post list for social module
    func fetchPostListAsyncCall() {
        let urlString   = URLConstants.postList
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
    
    func fetchFollowedPostListAsyncCall() {
        let urlString   = URLConstants.followedPosts
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
    
    func heightOfPostCell(model: SocialPost) -> CGFloat {
        var contentText = ""
        
        if model.type == "POLL" {
            contentText = model.question
        } else {
            contentText = model.descriptn
        }
        let userDetailHeight: CGFloat = 100
        let contentHeight = contentText.heightOfString2(width: screenWidth - 40, font: fontRegular(15))
        let imageHeight = model.postImages.count == 0 ? 0 : screenWidth //screenWidth - 30
        let matchHeight:CGFloat = model.matchDetail == "" ? 0 : 110
        let pollHeight: CGFloat = model.type == "POLL" ? CGFloat(40 + (model.pollArray.count * 60)) : 0
        let commentHeight:CGFloat = model.type == "POLL" ? 0 : 50
        
        let totalHeight = userDetailHeight + contentHeight + imageHeight + matchHeight + pollHeight + commentHeight
        
        return totalHeight
    }
}

//class SocialFollowedPostsVM: APIServiceManager<SocialPostListResponse> {
//    init () {}
//    static let shared = SocialFollowedPostsVM()
//    
//    ///function to fetch post list for social module
//    func fetchPostListAsyncCall() {
//        let urlString   = URLConstants.followedPosts
//        let method      = RequestType.get
//        asyncCall(urlString: urlString, method: method, parameters: nil)
//    }
//}


class SocialPostVM: APIServiceManager<BasicAPIResponse> {
    init () {}
    static let shared = SocialPostVM()
    
    ///function to add or edit post for social module
    func addEditPostListAsyncCall(isForEdit:Bool, postId:Int, parameters: [String: Any]) {
        let urlString   = isForEdit ? URLConstants.post + "/\(postId)": URLConstants.post
        let method      = isForEdit ? RequestType.put : RequestType.post
        asyncCall(urlString: urlString, method: method, parameters: parameters)
    }
}

class SocialDeleteVM: APIServiceManager<BasicAPIResponse> {
    init () {}
    static let shared = SocialDeleteVM()
    
    ///function to delete a post or a poll
    func deletePollOrPost(type: postType, id:Int) {
        let urlString   = (type == .poll ? URLConstants.deletePoll : URLConstants.post) + "/\(id)"
        let method      = RequestType.delete
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}

class SocialPollVM: APIServiceManager<BasicAPIResponse> {
    init () {}
    static let shared = SocialPollVM()
    
    ///function to add or edit poll for social module
    func addEditPollListAsyncCall(isForEdit:Bool, pollId:Int, parameters: [String: Any]) {
        let urlString   = isForEdit ? URLConstants.updatePoll + "\(pollId)" : URLConstants.addPoll
        let method      = isForEdit ? RequestType.put : RequestType.post
        asyncCall(urlString: urlString, method: method, parameters: parameters)
    }
}

class SocialLikeCommentListVM: APIServiceManager<SocialCommentResponse> {
    init () {}
    static let shared = SocialLikeCommentListVM()
    var commentsArray: [SocialComment] = []
    
    ///function to fetch post comment list for social module
    func fetchCommentListAsyncCall(postId: Int) {
        let urlString   = URLConstants.socialComment + "/list/\(postId)"
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
    
    ///function to fetch post like list for social module
    func fetchLikeListAsyncCall(postId: Int) {
        let urlString   = URLConstants.socialLike + "/list/\(postId)"
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}

class SocialAddLikeVM: APIServiceManager<BasicAPIResponse> {
    init () {}
    static let shared = SocialAddLikeVM()
    
    ///function to like or dislike a post for social module
    func addLikeAsyncCall(dislike: Bool = false, postId: Int) {
        let urlString   = dislike ? URLConstants.socialDislike : URLConstants.socialLike
        let method      = RequestType.post
        asyncCall(urlString: urlString, method: method, parameters: ["post_id": postId])
    }
}

class SocialAddCommentVM: APIServiceManager<BasicAPIResponse> {
    init () {}
    static let shared = SocialAddCommentVM()
    
    ///function to add comment for a post for social module
    func addCommentAsyncCall(parameters: [String: Any]) {
        let urlString   = URLConstants.socialComment
        let method      = RequestType.post
        asyncCall(urlString: urlString, method: method, parameters: parameters)
    }
}

class SocialDeleteCommentVM: APIServiceManager<BasicAPIResponse> {
    init () {}
    static let shared = SocialDeleteCommentVM()
    
    ///function to delete a comment
    func deleteComment(id: Int) {
        let urlString   = URLConstants.socialComment + "/\(id)"
        let method      = RequestType.delete
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}


class SocialPostReportVM: APIServiceManager<BasicAPIResponse> {
    static let shared = SocialPostReportVM()
    
    ///function to add comment for a post for social module
    func reportPostOrPollAsyncCall(reportType: ReportType, parameters: [String: Any]) {
        let urlString   = reportType == .reportPost ? URLConstants.blockPost :  URLConstants.blockPoll
        let method      = RequestType.post
        asyncCall(urlString: urlString, method: method, parameters: parameters)
    }
}
