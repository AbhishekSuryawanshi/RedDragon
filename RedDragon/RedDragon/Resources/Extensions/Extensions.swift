//
//  Extensions.swift
//  RedDragon
//
//  Created by Qasr01 on 24/10/2023.
//

import UIKit

extension UITableView {
    /// To show placeholder text in tableview if date is empty
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 100, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message.localized
        messageLabel.textColor = .darkGray
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = fontRegular(15)
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel;
    }
    ///To remove placeholder text
    func restore() {
        self.backgroundView = nil
    }
}

extension UICollectionView {
    /// To show placeholder text in collectionview if date is empty
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 100, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message.localized
        messageLabel.textColor = .darkGray
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = fontRegular(15)
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel;
    }
    ///To remove placeholder text
    func restore() {
        self.backgroundView = nil
    }
}

extension Date {
    /// Here we are converting date in Date format to given output format date string
    /// Showing localized date
    func formatDate(outputFormat: dateFormat)-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = outputFormat.rawValue
        dateFormatter.locale = Locale(identifier: UserDefaultString.language.contains("zh") ? "zh-Hans" : "en")
        return dateFormatter.string(from: self)
    }
}

extension Int {
    /// Here we are converting date in Unixtime (Number/Int) format to given output format date string
    /// Showing localized date
    func formatDate(outputFormat: dateFormat, today: Bool = false) -> String {
        let date = formatTimestampDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = outputFormat.rawValue
        dateFormatter.timeZone = .current
        dateFormatter.locale = Locale(identifier: UserDefaultString.language.contains("zh") ? "zh-Hans" : "en")
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
