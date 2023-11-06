//
//  SocialPostViewModel.swift
//  RedDragon
//
//  Created by Qasr01 on 01/11/2023.
//

import Foundation

class SocialPostListVM: APIServiceManager<[SocialPost]> {
    init () {}
    static let shared = SocialPostListVM()
    
    ///function to fetch post list for social module
    func fetchPostListAsyncCall() {
        let urlString   = URLConstants.postList
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
    
    func heightOfPostCell(model: SocialPost) -> CGFloat {
        var contentText = ""
        
        if model.type == "POLL" {
            contentText = model.descriptn == "_Test_" ? "" : model.descriptn
        } else {
            if let content = model.contentHtml.attributedHtmlString {
                contentText = content.string
            }
        }
        
        let contentHeight = contentText.heightOfString2(width: screenWidth - 30, font: fontRegular(15))
        //ToDo
        let questienHeight = 0.5 //model.question.heightOfString2(width: screenWidth - 60, font: fontRegular(16))
        let imageHeight = model.postImages.count == 0 ? 0 : screenWidth - 30 //screenWidth - 40
        let matchHeight:CGFloat = model.matchDetail == "" ? 0 : 95
        let pollHeight = model.type == "POLL" ? (questienHeight + (model.userPoll.answer == 0 ? 190 : 185)) : 0
        let commentHeight:CGFloat = model.type == "POLL" ? 0 : 50
        
        let totalHeight = contentHeight + questienHeight + imageHeight + matchHeight + pollHeight + commentHeight
        
        return totalHeight + 100
    }
}

class SocialPostVM: APIServiceManager<SocialPost> {
    init () {}
    static let shared = SocialPostVM()
    
    ///function to add or edit post for social module
    func addEditPostListAsyncCall(isForEdit:Bool, postId:Int, parameters: [String: Any]) {
        let urlString   = isForEdit ? URLConstants.post + "/\(postId)": URLConstants.post
        let method      = isForEdit ? RequestType.put : RequestType.post
        asyncCall(urlString: urlString, method: method, parameters: parameters)
    }
}

class SocialPollVM: APIServiceManager<BasicResponse> {
    init () {}
    static let shared = SocialPollVM()
    
    ///function to add or edit poll for social module
    func addEditPostListAsyncCall(isForEdit:Bool, pollId:Int, parameters: [String: Any]) {
        let urlString   = isForEdit ? URLConstants.updatePoll + "\(pollId)" : URLConstants.addPoll
        let method      = isForEdit ? RequestType.put : RequestType.post
        asyncCall(urlString: urlString, method: method, parameters: parameters)
    }
    
    ///function to delete a post or a poll
    func deletePollOrPost(type: postType, id:Int) {
        let urlString   = (type == .poll ? URLConstants.deletePoll : URLConstants.post) + "/\(id)"
        let method      = RequestType.delete
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}

class SocialLikeCommentListVM: APIServiceManager<[Social]> {
    init () {}
    static let shared = SocialLikeCommentListVM()
    var commentsArray: [Social] = []
    
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

class SocialLikeCommentVM: APIServiceManager<BasicResponse> {
    init () {}
    static let shared = SocialLikeCommentVM()
    
    ///function to like or dislike a post for social module
    func addLikeAsyncCall(dislike: Bool = false, postId: Int) {
        let urlString   = dislike ? URLConstants.socialDislike : URLConstants.socialLike
        let method      = RequestType.post
        asyncCall(urlString: urlString, method: method, parameters: ["post_id": postId])
    }
    
    ///function to add comment for a post for social module
    func addCommentAsyncCall(parameters: [String: Any]) {
        let urlString   = URLConstants.socialComment
        let method      = RequestType.post
        asyncCall(urlString: urlString, method: method, parameters: parameters)
    }
    
    ///function to delete a comment
    func deleteComment(id: Int) {
        let urlString   = URLConstants.socialComment + "/\(id)"
        let method      = RequestType.delete
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}
