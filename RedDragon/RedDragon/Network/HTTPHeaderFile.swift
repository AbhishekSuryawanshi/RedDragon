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
        //return ["Authorization": "Bearer " + "90|jgitYHX5xNhBbOS1cJ3vFs05X2hffoMU9kM58cO0"]
    }
    
    static var zeyuapiHeaders: [String: String] {
        return [
            "time": String(Date.currentTimeStamp),
            "random": "ksdklfkdnsfnjksdfksdfj",
            "sign":"ME1DWnBqYWcyWEJuRWFoU0djM1VGemhpa0JsSklBWHg=",
            "client":"pc"
        ]
    }
}
