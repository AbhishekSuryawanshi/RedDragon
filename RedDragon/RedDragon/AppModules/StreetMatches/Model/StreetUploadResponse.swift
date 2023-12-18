//
//  StreetUploadResponse.swift
//  RedDragon
//
//  Created by Remya on 12/5/23.
//

import Foundation

struct StreetUploadResponseRoot: Codable {
    let response: StreetUploadResponseData?
    let error: StreetUploadResponseData?
}

struct StreetUploadResponseData: Codable {
    let code: Int?
    let messages: [String]?
    let data: UploadResponse?
}
struct UploadResponse:Codable {
    
    let path: String?
}
