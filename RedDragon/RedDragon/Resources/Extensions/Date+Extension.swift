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
    static var currentTimeStamp: Int64 {
           return Int64(Date().timeIntervalSince1970 * 1000)
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

extension Date {

    /// Returns a Date with the specified amount of components added to the one it is called with
    func add(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date? {
        let components = DateComponents(year: years, month: months, day: days, hour: hours, minute: minutes, second: seconds)
        return Calendar.current.date(byAdding: components, to: self)
    }

    /// Returns a Date with the specified amount of components subtracted from the one it is called with
    func subtract(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date? {
        return add(years: -years, months: -months, days: -days, hours: -hours, minutes: -minutes, seconds: -seconds)
    }

}
