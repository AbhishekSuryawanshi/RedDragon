//
//  UserDetailModel.swift
//  VinderApp
//
//  Created by iOS Dev on 12/10/2023.
//

import Foundation
// MARK: - Users List
struct MeetUserListModel: Codable {
    let response: MeetUserList?
}

struct MeetUserList: Codable {
    let code: Int?
    let messages: [String]?
    let data: [MeetUser]?
}

// MARK: - UserData
struct MeetUserDetailModel: Codable {
    let response: MeetUserDetailResponse
}

// MARK: - UserDetail
struct MeetUserDetailResponse: Codable {
    let messages: [String]?
    let data: MeetUser?
}

// MARK: - LikedUser
struct MeetLikedUserModel: Codable {
    let response: MeetLikedUser?
}

struct MeetLikedUser: Codable {
    let messages: [String]?
    let data: MeetUser?
}

// MARK: - UnMatchUser
struct UnMatchOrBlockMeetUserModel: Codable {
    let response: UnMatchMeetUser?
}

struct UnMatchMeetUser: Codable {
    let messages: [String]?
    let code: Int?
}

struct MeetUser: Codable {
    let id, level, likedTo: Int?
    let name, about: String?
    let email: String?
    let location: String?
    let profileImg: String?
    let sportsInterest: [SportsInterest]?
    let eventList: [MeetEvent]?
    let isMatch: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, name, email, about, level
        case location = "location_name"
        case profileImg = "profile_img"
        case sportsInterest = "sports_interest"
        case eventList = "myevents"
        case likedTo = "liked_to"
        case isMatch = "liked_you_too"
    }
}

struct SportsInterest: Codable {
    let id: Int?
    let name: String?
    let sportImage: ImageURLS?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case sportImage = "image_urls"
    }
}

struct ImageURLS: Codable {
    let image: String?
    
    enum CodingKeys: String, CodingKey {
        case image = "3x"
    }
}

// MARK: - Events List
struct MeetUserSportsInterestModel: Decodable {
    let response: MeetUserSportsInterestList?
}

struct MeetUserSportsInterestList: Decodable {
    let messages: [String]?
    let data: [SportsInterest]?
}
