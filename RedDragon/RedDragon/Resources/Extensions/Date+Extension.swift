//
//  Date+Extension.swift
//  RedDragon
//
//  Created by Qasr01 on 24/11/2023.
//

import Foundation

///function named "formatDate" is available in Date, String, Int extension files.
extension Date {
    
    static var tomorrow:  Date { return Date().dayAfter }
    static var today: Date {return Date()}
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    }
    /// Here we are converting date in Date format to given output format date string
    /// Showing localized date
    func formatDate(outputFormat: dateFormat)-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = outputFormat.rawValue
        dateFormatter.locale = Locale(identifier: (UserDefaults.standard.language ?? "").contains("zh") ? "zh-Hans" : "en")
        return dateFormatter.string(from: self)
    }
}
