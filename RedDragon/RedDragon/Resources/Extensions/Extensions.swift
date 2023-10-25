//
//  Extensions.swift
//  RedDragon
//
//  Created by Qasr01 on 24/10/2023.
//

import UIKit

extension UITableView {
    
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
    
    func restore() {
        self.backgroundView = nil
    }
}

extension UICollectionView {
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
    
    func restore() {
        self.backgroundView = nil
    }
}

extension Date {
    
    func formatDate(outputFormat: dateFormat)-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = outputFormat.rawValue
        dateFormatter.locale = Locale(identifier: UserDefaultString.language.contains("zh") ? "zh-Hans" : "en")
        return dateFormatter.string(from: self)
    }
}

extension Int {
    //Unixtime
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
    
    func formatTimestampDate() -> Date {
        let timestamp: TimeInterval = TimeInterval(self)
        let date = Date(timeIntervalSince1970: timestamp)
        return date
    }
}
