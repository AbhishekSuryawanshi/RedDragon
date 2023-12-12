//
//  EnumConstants.swift
//  RedDragon
//
//  Created by Qasr01 on 27/11/2023.
//

import Foundation

/// Enum constant for all modules, developer can add new types
/// use separate array for each module
/// let sportsTypeArray: [SportsType] = [.football, .basketball, .tennis]

public enum SportsType: String {
    case all         = "All"
    case football    = "Football"
    case basketball  = "Basketball"
    case tennis      = "Tennis"
    case handball    = "Handball"
    case hockey      = "Hockey"
    case volleyball  = "Volleyball"
    case eSports     = "Esports"
    case cricket     = "Cricket"
    case athletics   = "Athletics"
    case motorsport  = "Motorsport"
    case races       = "Races"
    case others      = "Others"
    
    var sourceNewsKey: String {
        switch self {
        case .football:
            return "football"
        case .cricket:
            return "cricket"
        case .hockey:
            return "hockey"
        case .tennis:
            return "tennis"
        case .athletics:
            return "athletics"
        case .motorsport:
            return "motorsport"
        case .races:
            return "races"
        case .others:
            return "other-sports"
        case .all:
            return ""
        case .basketball:
            return ""
        case .handball:
            return ""
        case .volleyball:
            return ""
        case .eSports:
            return ""
        }
    }
}
