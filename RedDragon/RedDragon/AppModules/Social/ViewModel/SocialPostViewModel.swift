//
//  SocialPostViewModel.swift
//  RedDragon
//
//  Created by Qasr01 on 01/11/2023.
//

import Foundation

class SocialPostVM: APIServiceManager<[SocialPost]> {
    init () {}
    static let shared = SocialPostVM()
    
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
        
        let contentHeight = contentText.heightOfString2(width: screenWidth - 70, font: fontRegular(14))
        //ToDo
        let questienHeight = 0.5 //model.question.heightOfString2(width: screenWidth - 60, font: fontRegular(16))
        let imageHeight = model.postImages.count == 0 ? 0 : screenWidth - 60 //screenWidth - 40
        let matchHeight:CGFloat = model.matchDetail == "" ? 0 : 85
        let pollHeight = model.type == "POLL" ? (questienHeight + (model.userPoll.answer == 0 ? 190 : 185)) : 0
        let commentHeight:CGFloat = model.type == "POLL" ? 0 : 80
        
        let totalHeight = contentHeight + questienHeight + imageHeight + matchHeight + pollHeight + commentHeight
        
        return totalHeight + 95
    }
}
