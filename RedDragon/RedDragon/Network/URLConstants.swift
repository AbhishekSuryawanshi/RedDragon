//
//  URLConstants.swift
//  RedDragon
//
//  Created by QASR02 on 23/10/2023.
//

import Foundation

struct URLConstants {
    
    static let baseURL          = ""
    static let leagueDetail     = "https://app.8com.cloud/api/v1/sportscore/data/league.php"
    
    // MARK: -  Social
    
    static let socialBaseURL     = "https://muheh.com/euro5leagues/"
    
    //Match
    static let foootballLeague   = socialBaseURL + "api/league/list"
    static let foootballTeam     = socialBaseURL + "api/team/list"
    static let foootballMatch    = socialBaseURL + "api/match/list"
    
    //Post
    static let postList          = socialBaseURL + "api/poll-post"
    static let post              = socialBaseURL + "api/post"
    static let blockPost         = socialBaseURL + "api/post/block"
    
    static let like              = socialBaseURL + "api/likes"
    static let dislike           = socialBaseURL + "api/likes/unlike"
    static let comment           = socialBaseURL + "api/comments"
    
    static let addPoll           = socialBaseURL + "api/poll/save"
    static let updatePoll        = socialBaseURL + "api/poll/update/"
    static let deletePoll        = socialBaseURL + "api/poll/delete"
    static let blockPoll         = socialBaseURL + "api/poll/block"
}
