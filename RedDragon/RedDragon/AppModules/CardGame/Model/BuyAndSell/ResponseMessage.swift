//
//  ResponseMessage.swift
//  RedDragon
//
//  Created by QASR02 on 06/12/2023.
//

import Foundation

struct ResponseMessage: Decodable {
    let response: MessageResponse
}

// MARK: - Response
struct MessageResponse: Decodable {
    let code: Int
    let messages: [String]
    let data: Message
}


struct Message: Decodable {
    let message: String
}
