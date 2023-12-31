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
    case yyyyMMddHHmmss       = "yyyy-MM-dd HH:mm:ss"  // 2023-04-30 16:00:00
    case ddMMyyyyHHmm         = "yyyy/MM/dd HH:mm:ss"
    case ddMMyyyyWithTimeZone = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // 2023-09-30T13:27:38.000000Z
    case ddMMMyyyyhmma        = "d MMM yyyy . h:mm a" // 11 Nov 2023 . 5:12 PM
    case ddMMyyyy             = "dd-MM-yyyy"
    case ddMMyyyy2            = "dd/MM/yyyy" // 12/08/2023
    case ddMMM                = "dd MMM"
    case yyyyMMdd             = "yyyy-MM-dd"
    case hhmmss               = "hh:mm:ss"
    case hhmmaddMMMyyyy       = "hh:mm a | d MMMM yyyy"
    case hhmmaddMMMyyyy2      = "hh:mm a - dd/MM/yyyy" // 11.00 PM - 03/11/2023
    case hmma                 = "hh:mm a"
    case ed                   = "E, d"
    case edmmmHHmm            = "E, d MMM HH:mm"
    case mmmdhm               = "MMM d, h:mm a"
    case mmmdyyyyhma          = "MMM dd, yyyy hh:mm a" // Oct 30, 2023 10:26 pm
    case mmmmdyyyyhma         = "MMMM dd, yyyy hh:mm a" // December 15, 2023 11:30 am
    case hhmmssa              = "h:mm:ss aa"
}
