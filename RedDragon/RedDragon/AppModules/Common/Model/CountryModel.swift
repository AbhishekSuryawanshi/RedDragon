//
//  CountryModel.swift
//  RedDragon
//
//  Created by Qasr01 on 04/01/2024.
//

import Foundation

struct CountryListDataResponse: Codable {
    let response: CountryListData?
    let error: CountryListData?
}

struct CountryListData: Codable {
    let code: Int?
    let messages: [String]?
    let data: [Country]?
}

struct Country: Codable {
    var id: Int = 0
    var name: String = ""
    var flag: String = ""
    var CountryCode: String = ""
    var phoneCode: String  = ""
    
    enum CodingKeys: String, CodingKey {
        case id, name, flag
        case CountryCode = "code"
        case phoneCode = "dial_code"
    }
}

