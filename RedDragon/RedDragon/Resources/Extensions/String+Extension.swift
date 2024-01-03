//
//  String+Extension.swift
//  RedDragon
//
//  Created by Qasr01 on 28/12/2023.
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
                    return "Now".localized
                }
            } else if Calendar.current.isDateInYesterday(date) {
                return "Yesterday".localized + ", \(dateFormatterPrint.string(from: date))"
            } else {
                dateFormatterPrint.dateFormat = dateFormat.ddMMMyyyyhmma.rawValue
                return dateFormatterPrint.string(from: date)
            }
        } else {
            print("There was an error decoding the string")
            return ""
        }
    }
    
    ///here we are checking app localization and based on language, we are returning localization key for Chinese/English
    var localized: String {
        return Translation.shared.getTranslation(for: self)
    }
    
    ///here, we are considering only English and Chinese localization to match keyword from the API data, since we have only en and zh langugae "key:value" data in the API response
    var fixedLocaized: String {
        if let _ = UserDefaults.standard.string(forKey: UserDefaultString.language) {} else {
            // we set a default, just in case
            UserDefaults.standard.set("en", forKey: UserDefaultString.language)
            UserDefaults.standard.synchronize()
        }
        
        var lang = UserDefaults.standard.string(forKey: UserDefaultString.language) ?? "en"
        if lang.contains("zh") {
            lang = "zh-Hans"
        }
        else {
            lang = "en"
        }
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
    
    func size(OfFont font: UIFont) -> CGSize {
        return (self as NSString).size(withAttributes: [NSAttributedString.Key.font: font])
    }
    
    func heightOfString(width: CGFloat, font: UIFont) -> CGFloat {
        let size = CGSize(width: width, height: self.size(withAttributes: [NSAttributedString.Key.font : font]).height)
        return size.height
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
    
    func getFormattedDate(from inputDateformat: String, andConvertTo outputDateFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = inputDateformat
        guard let date = formatter.date(from: self) else { return "" }
        
        formatter.dateFormat = outputDateFormat
        let outputDate = formatter.string(from: date)
        return outputDate
    }
    
    func getNewsSource() -> (String, UIImage) {
        switch self {
        case "thehindu":
            return ("The Hindu", .theHinduLogo)
        case "handball-planet":
            return ("Handball Planet", .handBallPlanetLogo)
        case "worldofvolley":
            return ("WorldofVolley", .worldofVolleyLogo)
        case "fansided":
            return ("FanSided", .fanSidedLogo)
        case "esports":
            return ("eSports", .aiSportLogo)
        default:
            return ("", .placeholder1)
        }
    }
    
    func getCountryCallingCode() -> String {
        let prefixCodes = ["AF": "93", "AE": "971", "AL": "355", "AN": "599", "AS":"1", "AD": "376", "AO": "244", "AI": "1", "AG":"1", "AR": "54","AM": "374", "AW": "297", "AU":"61", "AT": "43","AZ": "994", "BS": "1", "BH":"973", "BF": "226","BI": "257", "BD": "880", "BB": "1", "BY": "375", "BE":"32","BZ": "501", "BJ": "229", "BM": "1", "BT":"975", "BA": "387", "BW": "267", "BR": "55", "BG": "359", "BO": "591", "BL": "590", "BN": "673", "CC": "61", "CD":"243","CI": "225", "KH":"855", "CM": "237", "CA": "1", "CV": "238", "KY":"345", "CF":"236", "CH": "41", "CL": "56", "CN":"86","CX": "61", "CO": "57", "KM": "269", "CG":"242", "CK": "682", "CR": "506", "CU":"53", "CY":"537","CZ": "420", "DE": "49", "DK": "45", "DJ":"253", "DM": "1", "DO": "1", "DZ": "213", "EC": "593", "EG":"20", "ER": "291", "EE":"372","ES": "34", "ET": "251", "FM": "691", "FK": "500", "FO": "298", "FJ": "679", "FI":"358", "FR": "33", "GB":"44", "GF": "594", "GA":"241", "GS": "500", "GM":"220", "GE":"995","GH":"233", "GI": "350", "GQ": "240", "GR": "30", "GG": "44", "GL": "299", "GD":"1", "GP": "590", "GU": "1", "GT": "502", "GN":"224","GW": "245", "GY": "595", "HT": "509", "HR": "385", "HN":"504", "HU": "36", "HK": "852", "IR": "98", "IM": "44", "IL": "972", "IO":"246", "IS": "354", "IN": "91", "ID":"62", "IQ":"964", "IE": "353","IT":"39", "JM":"1", "JP": "81", "JO": "962", "JE":"44", "KP": "850", "KR": "82","KZ":"77", "KE": "254", "KI": "686", "KW": "965", "KG":"996","KN":"1", "LC": "1", "LV": "371", "LB": "961", "LK":"94", "LS": "266", "LR":"231", "LI": "423", "LT": "370", "LU": "352", "LA": "856", "LY":"218", "MO": "853", "MK": "389", "MG":"261", "MW": "265", "MY": "60","MV": "960", "ML":"223", "MT": "356", "MH": "692", "MQ": "596", "MR":"222", "MU": "230", "MX": "52","MC": "377", "MN": "976", "ME": "382", "MP": "1", "MS": "1", "MA":"212", "MM": "95", "MF": "590", "MD":"373", "MZ": "258", "NA":"264", "NR":"674", "NP":"977", "NL": "31","NC":
            "687", "NZ":"64", "NI": "505", "NE": "227", "NG": "234", "NU":"683", "NF": "672", "NO": "47","OM": "968", "PK": "92", "PM": "508", "PW": "680", "PF": "689", "PA": "507", "PG":"675", "PY": "595", "PE": "51", "PH": "63", "PL":"48", "PN": "872","PT": "351", "PR": "1","PS": "970", "QA": "974", "RO":"40", "RE":"262", "RS": "381", "RU": "7", "RW": "250", "SM": "378", "SA":"966", "SN": "221", "SC": "248", "SL":"232","SG": "65", "SK": "421", "SI": "386", "SB":"677", "SH": "290", "SD": "249", "SR": "597","SZ": "268", "SE":"46", "SV": "503", "ST": "239","SO": "252", "SJ": "47", "SY":"963", "TW": "886", "TZ": "255", "TL": "670", "TD": "235", "TJ": "992", "TH": "66", "TG":"228", "TK": "690", "TO": "676", "TT": "1", "TN":"216","TR": "90", "TM": "993", "TC": "1", "TV":"688", "UG": "256", "UA": "380", "US": "1", "UY": "598","UZ": "998", "VA":"379", "VE":"58", "VN": "84", "VG": "1", "VI": "1","VC":"1", "VU":"678", "WS": "685", "WF": "681", "YE": "967", "YT": "262","ZA": "27" , "ZM": "260", "ZW":"263"]
        
        if let key = prefixCodes.first(where: { $0.value == self })?.key {
            return key
        } else {
            return ""
        }
    }
}

// MARK: - NSMutableAttributedString

extension NSMutableAttributedString {
   
    @discardableResult func light(_ text: String, size: CGFloat) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: fontLight(size)]
        let normalString = NSMutableAttributedString(string:text, attributes: attrs)
        append(normalString)
        return self
    }
    
    @discardableResult func regular(_ text: String, size: CGFloat) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: fontRegular(size)]
        let normalString = NSMutableAttributedString(string:text, attributes: attrs)
        append(normalString)
        return self
    }
    
    @discardableResult func regularColorText(_ text: String, size: CGFloat, color: UIColor) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: fontRegular(size), .foregroundColor: color]
        let normalString = NSMutableAttributedString(string:text, attributes: attrs)
        append(normalString)
        return self
    }
    
    //    @discardableResult func medium(_ text: String, size: CGFloat) -> NSMutableAttributedString {
    //        let attrs: [NSAttributedString.Key: Any] = [.font: fontMedium(size)]
    //        let normalString = NSMutableAttributedString(string:text, attributes: attrs)
    //        append(normalString)
    //        return self
    //    }
    //
    //    @discardableResult func mediumColorText(_ text: String, size: CGFloat, color: UIColor) -> NSMutableAttributedString {
    //        let attrs: [NSAttributedString.Key: Any] = [.font: fontMedium(size), .foregroundColor: color]
    //        let normalString = NSMutableAttributedString(string:text, attributes: attrs)
    //        append(normalString)
    //        return self
    //    }
    
    @discardableResult func semiBold(_ text: String, size: CGFloat) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: fontSemiBold(size)]
        let normalString = NSMutableAttributedString(string:text, attributes: attrs)
        append(normalString)
        return self
    }
    
    @discardableResult func semiBoldColorText(_ text: String, size: CGFloat, color: UIColor) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: fontSemiBold(size), .foregroundColor: color]
        let normalString = NSMutableAttributedString(string:text, attributes: attrs)
        append(normalString)
        return self
    }
    
    @discardableResult func bold(_ text: String, size: CGFloat) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: fontBold(size)]
        let normalString = NSMutableAttributedString(string:text, attributes: attrs)
        append(normalString)
        return self
    }
    
    public func addUnderLine(textToFind:String, remove: Bool = false) {
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(.underlineStyle, value: remove ? 0 : NSUnderlineStyle.thick.rawValue, range: foundRange)
        }
    }
    
    public func addLink(textToFind:String, linkURL:String) {//link color set by setting tint color in storyboard
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(.link, value: linkURL, range: foundRange)
            self.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.green, range: foundRange)
        }
    }
}
