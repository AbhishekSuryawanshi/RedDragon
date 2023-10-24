//
//  UIString+Extension.swift
//  RedDragon
//
//  Created by QASR02 on 23/10/2023.
//

import Foundation

extension String {
    
    // MARK: - Date and Time
    
    func formatDate(inputFormat: dateFormat, outputFormat: dateFormat, today: Bool = false)-> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = inputFormat.rawValue
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = outputFormat.rawValue
        dateFormatterPrint.locale = Locale(identifier: UserDefaultString.language.contains("zh") ? "zh-Hans" : "en")
        if let dateStr = dateFormatterGet.date(from: self) {
            if today && Calendar.current.isDateInToday(dateStr) {
                return "Today".localized
            }
            return dateFormatterPrint.string(from: dateStr)
        } else {
            print("There was an error decoding the string")
            return ""
        }
    }
    
    ///here we are checking app localization and based on language, we are returning localization key for Chinese/English
    var localized: String {
        if let _ = UserDefaults.standard.string(forKey: UserDefaultString.language) {} else {
            // we set a default, just in case
            UserDefaults.standard.set("en", forKey: UserDefaultString.language)
            UserDefaults.standard.synchronize()
        }
        
        var lang = UserDefaults.standard.string(forKey: UserDefaultString.language) ?? "en"
        if lang.contains("en") {
            lang = "en"
        }
        else if lang.contains("zh") {
            lang = "zh-Hans"
        }
        //lang = (lang == "en-US") ? "en" : lang
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
    
}
