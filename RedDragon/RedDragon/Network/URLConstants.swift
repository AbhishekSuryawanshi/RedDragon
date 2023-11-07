//
//  URLConstants.swift
//  RedDragon
//
//  Created by QASR02 on 23/10/2023.
//

import Foundation

struct URLConstants {
    
    static let appstore            = "https://apps.apple.com/app/id\(appStoreID)"
    static let appReview           = "itms-apps://itunes.apple.com/app/id\(appStoreID)?mt=8&action=write-review"
    static let privacyPolicy       = ""
    static let terms               = ""
    
    
    static let databaseBaseURL     = "https://datasport.one/api/v1/sportscore/data/"
    static let leagueDetail        = databaseBaseURL + "league.php"
    static let databaseMatchDetail = databaseBaseURL + "match.php"
    
    
    // MARK: -  Social
    
    static let socialBaseURL       = "https://muheh.com/euro5leagues/"
    
    //Match
    static let socialLeague        = socialBaseURL + "api/league/list"
    static let socialTeam          = socialBaseURL + "api/team/list"
    static let socialMatch         = socialBaseURL + "api/match/list"
    
    //Post
    static let postList            = socialBaseURL + "api/poll-post"
    static let post                = socialBaseURL + "api/post"
    static let blockPost           = socialBaseURL + "api/post/block"
    
    static let socialLike          = socialBaseURL + "api/likes"
    static let socialDislike       = socialBaseURL + "api/likes/unlike"
    static let socialComment       = socialBaseURL + "api/comments"
    
    static let addPoll             = socialBaseURL + "api/poll/save"
    static let updatePoll          = socialBaseURL + "api/poll/update/"
    static let deletePoll          = socialBaseURL + "api/poll/delete"
    static let blockPoll           = socialBaseURL + "api/poll/block"
    
    //Image
    static let postImage           = socialBaseURL + "api/resource/img"
}
