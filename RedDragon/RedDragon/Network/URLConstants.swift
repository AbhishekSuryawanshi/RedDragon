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
    static let terms               = "https://pitchstories.wordpress.com/terms-of-use/"
    static let baseURL             = "http://157.245.159.136:5072/api/"
    static let predictionBaseURL   = "http://45.76.178.21:5069/"
    static let newsBaseURL         = "https://www.77577.live"
    static let translationBaseURL  = "http://45.76.178.21:5072"

    // MARK: -  Login
    static let login               = baseURL + "login"
    static let register            = baseURL + "register"
    static let verifyOTP           = baseURL + "verifyotp"
    static let resendOTP           = baseURL + "resendotp"
    static let forgetPassword      = baseURL + "forgetPass"
    static let resetpassword       = baseURL + "resetpassword"
    static let logout              = baseURL + "logout"
    
    // MARK: - Home
    static let banners             = "https://api996.com/api/v1/banner/com.app.b8"
    static let bannerBaseURL       = "https://api996.com/"
    static let tagsURL             = baseURL + "user/tag/list"
    
    // MARK: -  Database
    static let databaseBaseURL     = "https://datasport.one/api/v1/sportscore/data/"
    static let leagueDetail        = databaseBaseURL + "league.php"
    static let databaseMatchDetail = databaseBaseURL + "match.php"
    static let analysisURL         = "api/predict/list?"
    
    // MARK: - CardGame
    static let cardGame_allPlayersList = databaseBaseURL + "player_filter.php"
    static let cardGame_buyPlayer  = baseURL + "sportcard/user/players"
    static let removePlayer        = baseURL + "sportcard/user/player"
    static let cardGame_leaderboard = baseURL + "sportcard/user/list"
    static let leaderboardDetail   = baseURL + "sportcard/user/"
    static let yourMatches         = baseURL + "sportcard/matches"
    static let updateUserInfo      = baseURL + "sportcard/user/info"
    
    // MARK: -  Social
    static let socialBaseURL       = baseURL + "euro5league/"
    static let euro5leagueBaseURL  = "https://muheh.com/euro5leagues/"
   
    //Match
    static let socialPublicLeague  = euro5leagueBaseURL + "api/league/list"
    static let socialPublicTeam    = euro5leagueBaseURL + "api/team/list"
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
    static let betAllMatches       = baseURL + "bet/match/get"
    static let allBets             = baseURL + "bet/play/get"
    static let points              = baseURL + "bet/account/wallet"
    static let placeBet            = baseURL + "bet/play/create"

    // MARK: -  Meet
    static let meetBaseURL         = "https://kicktin.com/vinder/api/"
    static let meetUserList        = baseURL + "vinder/listuser"
    static let meetHotEventList    = baseURL + "vinder/events/hot"
    static let meetAllEventList    = baseURL + "vinder/event/list"
    static let meetMyUpcomingEvent = baseURL + "vinder/events/upcoming"
    static let meetMyPastEvent     = baseURL + "vinder/events/past"
    static let meetLikedUser       = baseURL + "vinder/user/like"
    static let meetSportsInterest  = baseURL + "vinder/sports/interest/list"
    static let meetMyMatchUser     = baseURL + "vinder/user/mymatch/list"
    static let meetCreateEvent     = baseURL + "vinder/user/events/add"
    static let meetJoinEvent       = baseURL + "vinder/user/events/join"
    
    // MARK: - StreetMatches
    static let streetMatchesBaseURL = baseURL//"https://gsports.cloud/api/"

    static let streetHome           = streetMatchesBaseURL + "streetmatch/home/data"
    static let stadiumList          = streetMatchesBaseURL + "streetmatch/stadium/list"
    static let eventsList           = streetMatchesBaseURL + "streetmatch/event/list"
    static let streetMatchesList    = streetMatchesBaseURL + "streetmatch/match/list"
    static let stadiums             = streetMatchesBaseURL + "streetmatch/stadium"
    static let streetUploadImage    = streetMatchesBaseURL + "streetmatch/resource/img/upload"
    static let streetMatches        = streetMatchesBaseURL + "streetmatch/match"
    static let streetTeamList       = streetMatchesBaseURL + "streetmatch/team/list"
    static let streetTeamDetails    = streetMatchesBaseURL + "streetmatch/team"
    static let streetPlayersList    = streetMatchesBaseURL + "streetmatch/player/list"
    static let streetEvents         = streetMatchesBaseURL + "streetmatch/event"
    static let playerPositions      = streetMatchesBaseURL + "streetmatch/player/positions"
    static let eventRequests        = streetMatchesBaseURL + "streetmatch/event/request"
    static let streetPlayerProfile  = streetMatchesBaseURL + "streetmatch/auth/user"
    static let streetPlayers        = streetMatchesBaseURL + "streetmatch/player"
    static let streetUpdateProfile  = streetMatchesBaseURL + "streetmatch/user/info"
    

    // MARK: - Prediction
    static let getMatchesList       = "api/match/list?"
    static let postMatchPrediction  = "api/predict"
    static let matchDetail          = "api/match"
    static let predictionList       = "api/predict/list/withMatch?"
    static let predictionGetMatchList = baseURL + "prediction/match/list?"
    
    
    // MARK: - News
    static let newsGossips          = "https://datasport.one/api/v1/news/data.php"
    static let eSportsBaseURL       = "http://199.241.1.88:7001/"
    static let eSportsList          = eSportsBaseURL + "api/esports-news-list"
    static let eSportsDetail        = eSportsBaseURL + "api/specific-esports-news/"
    static let videosBaseURL        = "https://zeyuapi.com/v1/video/" //custom headers adding in APIServiceManager.swift
    static let videosList           = videosBaseURL + "recommend"
    static let videosThumbnail      = "https://34433tiyu.com/"
    static let chatTokenURL         = "https://grullo-chihuahua-4284.twil.io/chat-token"
    static let newsList             = "/api/post-keyword/"
    static let newsDetail           = "/api/post/"
    static let videoList            = "/api/video-list/"
    
    // Comments
    static let commentList          = baseURL + "user/comment/list"
    static let addComment           = baseURL + "user/comment/add"
    static let deleteComment        = baseURL + "user/comment/delete/"
    
    // MARK: - GlobalMatches
    static let globalMatchBaseURL     = "http://199.241.1.88:4049/api/"
    static let footballMatchList      = globalMatchBaseURL + "football/matchlist/today"
    static let basketballMatchList    = globalMatchBaseURL + "basketball/matchlist/today"
    static let footballH2HMatchList   = globalMatchBaseURL + "football/match-analysis/statics/"
    static let basketballH2HMatchList = globalMatchBaseURL + "basketball/match-analysis/statics/"
    
    // MARK: - Experts
    static let expertsBaseURL         = "http://157.245.159.136:5072/api"
    static let expertUserList         = expertsBaseURL + "/user/list"
    
    // MARK: - Wallet
    static let subscriptionList       = baseURL + "user/wallet/history"

    // MARK: - Translation
    static let translation            = "/get_translations.php"
}
