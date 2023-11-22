//
//  NotificationExtension.swift
//  RedDragon
//
//  Created by Qasr01 on 11/11/2023.
//

import Foundation

extension NSNotification {
    static let socialSearchEnable  = Notification.Name("socialSearchEnable")
    static let refreshHashTags     = Notification.Name("refreshHashTags")
    static let dismissLoginVC      = Notification.Name("dismissLoginVC")
    static let selectedSport      = Notification.Name("selectedSport")
}
