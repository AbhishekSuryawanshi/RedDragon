//
//  DeviceLanguage.swift
//  RedDragon
//
//  Created by Remya on 12/19/23.
//

import Foundation

struct DeviceLanguage {
    static func currentLanguage() -> String {
        let currentLanguage = (UserDefaults.standard.stringArray(forKey: "AppleLanguages") ?? [""]) //zh-Hans //en-US
        return "\(currentLanguage[0])"
    }
}
