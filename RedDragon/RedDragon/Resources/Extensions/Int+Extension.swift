//
//  Int+Extension.swift
//  RedDragon
//
//  Created by Qasr01 on 24/11/2023.
//

import Foundation

extension Int {
    /// Here we are converting date in Unixtime (Number/Int) format to given output format date string
    /// Showing localized date
    func formatDate(outputFormat: dateFormat, today: Bool = false) -> String {
        let date = formatTimestampDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = outputFormat.rawValue
        dateFormatter.timeZone = .current
        dateFormatter.locale = Locale(identifier: (UserDefaults.standard.language ?? "").contains("zh") ? "zh-Hans" : "en")
        let dateStr = dateFormatter.string(from: date)
        if today && Calendar.current.isDateInToday(date) {
            return "Today".localized
        } else {
            return dateStr
        }
    }
    /// Here we are converting date in Unixtime (Number/Int) format to date
    func formatTimestampDate() -> Date {
        let timestamp: TimeInterval = TimeInterval(self)
        let date = Date(timeIntervalSince1970: timestamp)
        return date
    }
}
