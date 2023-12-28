//
//  Utility.swift
//  RedDragon
//
//  Created by Abdullah on 29/11/2023.
//

import Foundation
import UIKit

class Utility {

    class func saveToUserDefaults<T: Any>(withKey key: String, and value: T) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
    }
    
    class func getCurrentLang() -> String {
        guard let lang = UserDefaults.standard.string(forKey: UserDefaultString.language) else {
            // we set a default, just in case
            UserDefaults.standard.set("en-US", forKey: UserDefaultString.language)
            return "en"
        }
        
        switch lang {
        case "en-US":
            return "en"
        case "zh-Hans":
            return "zh"
        default:
            return "en"
        }
    }

}
