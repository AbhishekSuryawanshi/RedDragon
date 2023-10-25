//
//  HTTPHeaderFile.swift
//  RedDragon
//
//  Created by QASR02 on 23/10/2023.
//

import Foundation

struct HTTPHeader {
    static var commonHeaders: [String: String] {
        return [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
    }
    
    static func createAuthorizationHeader(token: String) -> [String: String] {
        return ["Authorization": "Bearer " + token]
    }
}
