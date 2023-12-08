//
//  MeetEventModel.swift
//  RedDragon
//
//  Created by iOS Dev on 23/11/2023.
//

import Foundation

struct JoinOrInviteMeetEventRequest: Codable {
    var eventId: Int?
    
    enum CodingKeys: String, CodingKey {
        case eventId = "event_id"
    }
}

// MARK: - Events List
struct MeetEventListModel: Codable {
    let response: MeetEventList?
}

struct MeetEventList: Codable {
    let messages: [String]?
    let data: [MeetEvent]?
    let code: Int?
}

// MARK: - Event Detail
struct MeetEventDetailModel: Codable {
    let response: MeetEventDetail?
    let error: ErrorResponse?
}

struct MeetEventDetail: Codable {
    let messages: [String]?
    let data: MeetEvent?
    let code: Int?
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
    var joined: Bool?
    
    enum CodingKeys: String, CodingKey {
        case eventId = "id"
        case userId = "user_id"
        case locationId = "location_id"
        case name, address, description, interest
        case longitude, latitude, date, invitee, joined
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

struct ErrorResponse: Codable {
    let code: Int?
    let messages: [String]?
}
