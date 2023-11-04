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
    
    func formatDate2(inputFormat: dateFormat)-> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = inputFormat.rawValue
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.locale = Locale(identifier: "en")
        if let date = dateFormatterGet.date(from: self) {
            
            dateFormatterPrint.dateFormat = dateFormat.hmma.rawValue
            
            if Calendar.current.isDateInToday(date) {
                let dateComponents = Calendar(identifier: .gregorian).dateComponents([.year, .day, .hour, .minute], from: date, to: Date())
                if dateComponents.year ?? 0 > 0 || dateComponents.day ?? 0 > 0 || dateComponents.hour ?? 0 > 0 {
                    return "Today".localized + ", \(dateFormatterPrint.string(from: date))"
                } else if dateComponents.minute ?? 0 > 0 {
                    if dateComponents.minute == 1  {
                        return "1 " + "minute ago".localized
                    } else if dateComponents.hour ?? 0 < 1   {
                        return "\(dateComponents.minute ?? 0) " + "minutes ago".localized
                    } else if dateComponents.hour ?? 0 == 1  {
                        return "1 " + "hour ago".localized
                    } else if dateComponents.hour ?? 0 <= 3  {
                        return "\(dateComponents.minute ?? 0) " + "hours ago".localized
                    } else {
                        return "Today".localized + ", \(dateFormatterPrint.string(from: date))"
                    }
                } else {
                    return "Moments ago".localized
                }
            } else if Calendar.current.isDateInYesterday(date) {
                return "Yesterday".localized + ", \(dateFormatterPrint.string(from: date))"
            } else {
                dateFormatterPrint.dateFormat = dateFormat.ddMMMyyyyhhmma.rawValue
                return dateFormatterPrint.string(from: date)
            }
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
    
    var attributedHtmlString: NSAttributedString? {
        try? NSAttributedString(
            data: Data(utf8),
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        )
    }
    
    func heightOfString2(width: CGFloat, font: UIFont) -> CGFloat {
        let label : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = self
        label.sizeToFit()
        return label.frame.height
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
