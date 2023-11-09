//
//  PostModel.swift
//  RedDragon
//
//  Created by Qasr01 on 30/10/2023.
//

import UIKit

struct SocialPost: Codable {
    
    var id: Int = 0 //It can be poll id or post id check "type"
    var type: String = ""
    var title: String  = ""
    var contentHtml: String  = ""
    var isVisible: Int = 0 // 0 1
    var leagueId: String = ""
    var userId: Int = 0
    var userImage: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var postImages: [String] = []
    var getPostImages: [SocialPostImage] = []
    var updatedTime: String = ""
    var createdTime: String = ""
    var matchDetail: String = ""
    var matchModel = SocialMatch()
    var liked: Bool = false
    var likeCount: Int = 0
    var commentCount: Int = 0
    
    //Poll
    var user_id: Int = 0 //for parsing only
    var descriptn: String = ""
    var userPoll = PollAnswer()//  1 2 3
    var option_1: String = ""
    var option_2: String = ""
    var option_3: String = ""   //Note: question key is used as option_3
    var option_1Count: Int = 0
    var option_2Count: Int = 0
    var option_3Count: Int = 0
    
    var pollArray: [Poll] = []
    
    enum CodingKeys: String, CodingKey {
        case id, type, title, user_id, option_1, option_2
        case contentHtml = "content_html"
        case descriptn = "description"
        case isVisible = "is_visible"
        case leagueId = "league_id"
        case userId = "creator_user_id"
        case userImage = "user_image"
        case firstName = "first_name"
        case lastName = "last_name"
        case getPostImages = "post_images"
        case liked = "is_logged_user_liked"
        case likeCount = "likes_cnt"
        case commentCount = "comments_cnt"
        case matchDetail = "match_detail"
        case updatedTime = "updated_at"
        case createdTime = "created_at"
        case userPoll = "logged_user_answer"
        case option_1Count = "option_1_count"
        case option_2Count = "option_2_count"
        case option_3Count = "option_3_count"
        case option_3 = "question"
    }
    
    public init () {}
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try (container.decodeIfPresent(Int.self, forKey: .id) ?? 0)
        type = try (container.decodeIfPresent(String.self, forKey: .type) ?? "")
        title = try (container.decodeIfPresent(String.self, forKey: .title) ?? "")
        
        isVisible = try (container.decodeIfPresent(Int.self, forKey: .isVisible) ?? 0)
        leagueId = try (container.decodeIfPresent(String.self, forKey: .leagueId) ?? "")
        userId = try (container.decodeIfPresent(Int.self, forKey: .userId) ?? 0)
        userImage = try (container.decodeIfPresent(String.self, forKey: .userImage) ?? "")
        firstName = try (container.decodeIfPresent(String.self, forKey: .firstName) ?? "")
        lastName = try (container.decodeIfPresent(String.self, forKey: .lastName) ?? "")
        getPostImages = try (container.decodeIfPresent([SocialPostImage].self, forKey: .getPostImages) ?? [])
        postImages = getPostImages.map({$0.imageUrl})
        
        matchDetail = try (container.decodeIfPresent(String.self, forKey: .matchDetail) ?? "")
        if matchDetail != "" {
            let jsonData = Data(matchDetail.utf8)//matchDetail.data(using: .utf8)!
            let decoder = JSONDecoder()
            do {
                matchModel = try decoder.decode(SocialMatch.self, from: jsonData)
            } catch {
            }
        }
        
        liked = try (container.decodeIfPresent(Bool.self, forKey: .liked) ?? false)
        likeCount = try (container.decodeIfPresent(Int.self, forKey: .likeCount) ?? 0)
        commentCount = try (container.decodeIfPresent(Int.self, forKey: .commentCount) ?? 0)
        updatedTime = try (container.decodeIfPresent(String.self, forKey: .updatedTime) ?? "")
        createdTime = try (container.decodeIfPresent(String.self, forKey: .createdTime) ?? "")
        descriptn = try (container.decodeIfPresent(String.self, forKey: .descriptn) ?? "")
        userPoll = try (container.decodeIfPresent(PollAnswer.self, forKey: .userPoll) ?? PollAnswer())
        option_1 = try (container.decodeIfPresent(String.self, forKey: .option_1) ?? "")
        option_2 = try (container.decodeIfPresent(String.self, forKey: .option_2) ?? "")
        //option_3 = try (container.decodeIfPresent(String.self, forKey: .option_3) ?? "")
        option_1Count = try (container.decodeIfPresent(Int.self, forKey: .option_1Count) ?? 0)
        option_2Count = try (container.decodeIfPresent(Int.self, forKey: .option_2Count) ?? 0)
        option_3Count = try (container.decodeIfPresent(Int.self, forKey: .option_3Count) ?? 0)
        user_id = try (container.decodeIfPresent(Int.self, forKey: .user_id) ?? 0)
        ///html content from contentHtml saved to description
        contentHtml = try (container.decodeIfPresent(String.self, forKey: .contentHtml) ?? "")
        
        if type == "POLL" {
            userId = user_id
        } else {
            if let content = contentHtml.attributedHtmlString {
                descriptn = content.string
            }
        }
        pollArray.removeAll()
        if option_3Count != 0 {
            print("======== ---")
        }
       
        if option_1 != "" {
            let poll_1 = Poll(title: option_1, count: option_1Count)
            pollArray.append(poll_1)
        }
        if option_2 != "" {
            let poll_2 = Poll(title: option_2, count: option_2Count)
            pollArray.append(poll_2)
        }
        if option_3 != "" {
            let poll_3 = Poll(title: option_3, count: option_3Count)
            pollArray.append(poll_3)
        }
    }
}

struct Poll: Codable {
    var title: String = ""
    var count: Int = 0
}

struct PollAnswer: Codable {
    var answer: Int = 0
}

struct SocialPostImage: Codable {
    var imageUrl: String = ""
    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        imageUrl  = try (container.decodeIfPresent(String.self, forKey: .imageUrl) ?? "")
    }
}

struct Social: Codable {
    var id: Int = 0 //comment or like id
    var postId: Int = 0
    var updatedTime: String = ""
    var createdTime: String = ""
    var user = User()
    var comment: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id, user
        case comment = "txt"
        case postId = "post_id"
        case updatedTime = "updated_at"
        case createdTime = "created_at"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id  = try (container.decodeIfPresent(Int.self, forKey: .id) ?? 0)
        postId  = try (container.decodeIfPresent(Int.self, forKey: .postId) ?? 0)
        updatedTime = try (container.decodeIfPresent(String.self, forKey: .updatedTime) ?? "")
        createdTime = try (container.decodeIfPresent(String.self, forKey: .createdTime) ?? "")
        user  = try (container.decodeIfPresent(User.self, forKey: .user) ?? User())
        comment  = try (container.decodeIfPresent(String.self, forKey: .comment) ?? "")
    }
}

struct BasicResponse: Codable {
    let message: String?
}

struct ImageResponse: Codable {
    var postImage: String = ""
    
    public init () {}
    
    enum CodingKeys: String, CodingKey {
        case postImage = "url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        postImage = try (container.decodeIfPresent(String.self, forKey: .postImage) ?? "")
    }
}
