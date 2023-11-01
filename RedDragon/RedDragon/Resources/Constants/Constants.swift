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
    case ddMMMyyyyhhmma       = "d MMM yyyy . hh:mm a"
    case ddMMyyyy             = "dd-MM-yyyy"
    case ddMMyyyy2            = "dd/MM/yyyy"
    case hhmmaddMMMyyyy       = "hh:mm a | d MMMM yyyy"
    case hhmmaddMMMyyyy2      = "hh:mm a - dd/MM/yyyy"
    case hmma                 = "hh:mm a"
}
