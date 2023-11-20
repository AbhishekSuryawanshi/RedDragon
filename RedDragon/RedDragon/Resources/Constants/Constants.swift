//
//  Constants.swift
//  RedDragon
//
//  Created by Qasr01 on 24/10/2023.
//

import UIKit

let appStoreID = ""

let screenWidth  = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height


// MARK: - Date and Time
enum dateFormat: String {
    case yyyyMMddHHmm         = "yyyy-MM-dd HH:mm" 
    case ddMMyyyyWithTimeZone = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    case ddMMMyyyyhhmma       = "d MMM yyyy . hh:mm a"
    case ddMMyyyy             = "dd-MM-yyyy"
    case ddMMyyyy2            = "dd/MM/yyyy"
    case hhmmaddMMMyyyy       = "hh:mm a | d MMMM yyyy"
    case hhmmaddMMMyyyy2      = "hh:mm a - dd/MM/yyyy"
    case hmma                 = "hh:mm a"
    case edmmmHHmm            = "E, d MMM HH:mm"
}

func formatDate(date: Date?, with outputFormat: dateFormat)-> String
{
    if date == nil
    {
        return ""
    }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = outputFormat.rawValue
    dateFormatter.locale = Locale(identifier: "en")
    return dateFormatter.string(from: date!)
}
