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
            "Content-Type": "application/json",
            "db-num":"3"
        ]
    }
    
    static func createAuthorizationHeader(token: String) -> [String: String] {
        return ["Authorization": "Bearer " + token]
        //return ["Authorization": "Bearer " + "87|MCa9ot00xIU5JgG2KUsAd38X2NyGleoyjbdCLrP6"]
    }
}
