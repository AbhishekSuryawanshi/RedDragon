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
}
