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
    
    static let baseURL             = "http://157.245.159.136:5072/api/"
    
    
    // MARK: -  Login
    
    static let login               = baseURL + "login"
    static let register            = baseURL + "register"
    static let verifyOTP           = baseURL + "verifyotp"
    static let resendOTP           = baseURL + "resendotp"
    static let forgetPassword      = baseURL + "forgetPass"
    static let resetpassword       = baseURL + "resetpassword"
    
    // MARK: -  Database
    
    static let databaseBaseURL     = "https://datasport.one/api/v1/sportscore/data/"
    static let leagueDetail        = databaseBaseURL + "league.php"
    static let databaseMatchDetail = databaseBaseURL + "match.php"
    
    
    // MARK: -  Social
    
    static let socialBaseURL       = baseURL + "euro5league/"
   
    //Match
    static let socialLeague        = socialBaseURL + "league/list"
    static let socialTeam          = socialBaseURL + "team/list"
    static let socialMatch         = socialBaseURL + "match/list"
    
    //Post
    static let postList            = socialBaseURL + "poll-post"
    static let post                = socialBaseURL + "post"
    static let blockPost           = socialBaseURL + "post/block"
    
    static let socialLike          = socialBaseURL + "likes"
    static let socialDislike       = socialBaseURL + "likes/unlike"
    static let socialComment       = socialBaseURL + "comments"
    
    static let addPoll             = socialBaseURL + "poll/save"
    static let updatePoll          = socialBaseURL + "poll/update/"
    static let deletePoll          = socialBaseURL + "poll/delete"
    static let blockPoll           = socialBaseURL + "poll/block"
    
    //Image
    static let postImage           = socialBaseURL + "resource/img"
    
    
    // MARK: - PlayerDetail
    static let playerDetail        = databaseBaseURL + "player.php"
    
    
    //Bets
    static let betAllMatches     = "https://amberic.top/app8/api/bet/" + "match/get"
    static let allBets           = "https://amberic.top/app8/api/bet/" + "play/get"
}
