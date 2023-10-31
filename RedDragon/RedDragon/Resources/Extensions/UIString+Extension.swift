//
//  UIString+Extension.swift
//  RedDragon
//
//  Created by QASR02 on 23/10/2023.
//

import UIKit

extension String {
    
    /// Here we are converting date string in one format to given output format
    /// Showing localized date
    /// If parameter "today" is true, it will show "Today" instead of date string
    func formatDate(inputFormat: dateFormat, outputFormat: dateFormat, today: Bool = false)-> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = inputFormat.rawValue
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = outputFormat.rawValue
        dateFormatterPrint.locale = Locale(identifier: (UserDefaults.standard.language ?? "").contains("zh") ? "zh-Hans" : "en")
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
        if let _ = UserDefaults.standard.language {} else {
            // we set a default, just in case
            UserDefaults.standard.language = "en"
        }
        
        var lang = UserDefaults.standard.language ?? "en"
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

// MARK: - NSMutableAttributedString

extension NSMutableAttributedString {
    @discardableResult func underLineText(_ text: String, remove: Bool = false) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.underlineStyle: remove ? NSUnderlineStyle.thick.rawValue : 0]
        let formattedString = NSMutableAttributedString(string:text, attributes: attrs)
        append(formattedString)
        return self
    }
}
