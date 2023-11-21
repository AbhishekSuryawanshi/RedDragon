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

struct MeetUserDetailResponse: Codable {
    let messages: [String]?
    let data: MeetUser?
}

// MARK: - LikedUser
struct MeetLikedUserModel: Codable {
    let response: MeetLikedUser?
}

struct MeetLikedUser: Codable {
    let messages: String?
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

struct MeetEvent: Codable {
    var eventId, userId, locationId: Int?
    var address, date, time: String?
    var latitude, longitude: Double?
    var isPaid: Int?
    var bannerImage: ImageURLS?
    var name, description: String?
    var attending, invited: Bool?
    var interestId, peopleJoinedCount: Int?
    var price: Float?
    var creator: MeetUser?
    var interest: SportsInterest?
    var invitee: [Int]?
    
    enum CodingKeys: String, CodingKey {
        case eventId = "id"
        case userId = "user_id"
        case locationId = "location_id"
        case name, address, description, interest
        case longitude, latitude, date, invitee
        case isPaid = "is_paid"
        case time = "time_column"
        case invited, attending, price, creator
        case bannerImage = "banner_image"
        case interestId = "interest_id"
        case peopleJoinedCount = "attendees_count"
    }
    
    init(name:String, description:String, interestId:Int, latitude:Double, longitude:Double, date:String, time:String, address: String, isPaid: Int, price: Float) {
        self.name = name
        self.description = description
        self.interestId = interestId
        self.latitude = latitude
        self.longitude = longitude
        self.date = date
        self.time = time
        self.address = address
        self.isPaid = isPaid
        self.price = price
    }
}
