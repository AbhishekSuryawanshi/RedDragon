//
//  Extensions.swift
//  RedDragon
//
//  Created by Qasr01 on 24/10/2023.
//

import UIKit
import SDWebImage

extension UIView {
    /// To curve the sides of view
    /// add suitable corners in "corners" as [.topLeft, .topRight, .bottomLeft, .bottomRight, .allCorners]

    func roundCornersWithBorderLayer(cornerRadii: CGFloat, corners: UIRectCorner, bound:CGRect, borderColor: UIColor = .clear, borderWidth: CGFloat = 0) {
        let maskPath = UIBezierPath(roundedRect: bound, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadii, height: cornerRadii))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        self.layer.mask = shape
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = maskPath.cgPath
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = borderWidth
        borderLayer.frame = self.bounds
        self.layer.addSublayer(borderLayer)
    }
    
    /// To add shadow for view
    func applyShadow(radius: CGFloat,
                     opacity: Float,
                     offset: CGSize = .zero,
                     color: UIColor = .lightGray) {
        layer.masksToBounds = false
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
    }
    
    public class func fromNib(nibName: String? = nil) -> Self {
        return fromNib(nibName: nibName, type: self)
    }

    public class func fromNib<T: UIView>(nibName: String? = nil, type: T.Type) -> T {
        return fromNib(nibName: nibName, type: T.self)!
    }

    public class func fromNib<T: UIView>(nibName: String? = nil, type: T.Type) -> T? {
        var view: T?
        let name: String

        if let nibName = nibName {
            name = nibName
        } else {
            name = self.nibName
        }

        if let nibViews = Bundle.main.loadNibNamed(name, owner: nil, options: nil) {
            for nibView in nibViews {
                if let tog = nibView as? T {
                    view = tog
                }
            }
        }

        return view
    }

    public class var nibName: String {
        return "\(self)".components(separatedBy: ".").first ?? ""
    }

    public class var nib: UINib? {
        if let _ = Bundle.main.path(forResource: nibName, ofType: "nib") {
            return UINib(nibName: nibName, bundle: nil)
        } else {
            return nil
        }
    }
}

extension UIImageView {
    /// To set image and its activity indicator from image url
    func setImage(imageStr: String, placeholder: UIImage? = nil) {
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        if placeholder != nil {
            self.sd_setImage(with: URL(string: imageStr), placeholderImage: placeholder)
        } else {
            self.sd_setImage(with: URL(string: imageStr))
        }
    }
}

extension UITableView {
    /// Register a cell from external xib into a table instance.
    func register(_ nibName: String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        self.register(nib, forCellReuseIdentifier: nibName)
    }
    
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
    /// Register a cell from external xib into a collection instance.
    func register(_ nibName: String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: nibName)
    }
    
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

extension Encodable {
    var convertToString: String? {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try jsonEncoder.encode(self)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            return nil
        }
    }
}

extension Array {
    
    func uniques<T: Hashable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        return reduce([]) { result, element in
            let alreadyExists = (result.contains(where: { $0[keyPath: keyPath] == element[keyPath: keyPath] }))
            return alreadyExists ? result : result + [element]
        }
    }
}
