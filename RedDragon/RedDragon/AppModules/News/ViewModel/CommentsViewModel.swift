//
//  CommentsViewModel.swift
//  RedDragon
//
//  Created by Qasr01 on 13/12/2023.
//

import Foundation

class CommentListVM: APIServiceManager<CommentResponse> {
    init () {}
    static let shared = CommentListVM()
    
    ///function to get comment list
    func getCommentsAsyncCall(sectionId: String) {
        let urlString   = URLConstants.commentList + "?comment_section_id=\(sectionId)"
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}

class AddCommentVM: APIServiceManager<BasicAPIResponse> {
    init () {}
    static let shared = AddCommentVM()
    
    ///function to add comment
    func addCommentAsyncCall(parameters: [String: Any]) {
        let urlString   = URLConstants.addComment
        let method      = RequestType.post
        asyncCall(urlString: urlString, method: method, parameters: parameters)
    }
}

class DeleteCommentVM: APIServiceManager<BasicAPIResponse> {
    init () {}
    static let shared = DeleteCommentVM()
    
    ///function to delete comment
    func deleteCommentAsyncCall(id: Int) {
        let urlString   = URLConstants.deleteComment + "\(id)"
        let method      = RequestType.delete
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}
