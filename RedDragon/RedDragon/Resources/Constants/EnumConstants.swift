//
//  EnumConstants.swift
//  RedDragon
//
//  Created by Qasr01 on 27/11/2023.
//

import UIKit

/// Enum constant for all modules, developer can add new types
/// use separate array for each module
/// let sportsTypeArray: [SportsType] = [.football, .basketball, .tennis]

enum SportsType: String {
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

enum SettingType: String, CaseIterable {
    case account     = "Account"
    case privacy     = "Privacy Policy"
    case notiftn     = "Notifications"
    case langaug     = "Languages"
    case logout      = "Logout"
    case about       = "About Us"
    case support     = "Support"
    case help        = "Help Center"
    
    var iconImage: UIImage {
        switch self {
        case .account:
            return .manageAccounts
        case .privacy:
            return .privacyTip
        case .notiftn:
            return .notifications
        case .logout:
            return .report
        default:
            return .report
        }
    }
}

enum ProfileType: String, CaseIterable {
    case name      = "Full Name"
    case userName  = "User Name"
    case email     = "Email"
    case phone     = "Phone Number"
    case password  = "Password"
    case Gender    = "Gender"
    case dob       = "Date of Birth"
    case location  = "Location"
    case language  = "Language"
}

enum ServiceType: String, CaseIterable {
    case predictions = "Predictions"
    case bets        = "Bets"
    case social      = "Social"
    case fantasy     = "Fantasy"
    case quizz       = "Quizz"
    case matches     = "Matches"
    case updates     = "Updates"
    case database    = "Database"
    case analysis    = "Analysis"
    case users       = "Users"
    case street      = "Street Match"
    case meet        = "Meet app"
    case wallet      = "Wallet"
    case experts     = "Experts"
    case cards       = "Cards"
    
    var iconImage: UIImage {
        switch self {
        case .predictions:
            return .infoPredictions
        case .bets:
            return .infoBets
        case .social:
            return .infoSocial
        case .fantasy:
            return .infoFantasy
        case .quizz:
            return .infoQuiz
        case .matches:
            return .infoMatches
        case .updates:
            return .infoUpdates
        case .database:
            return .infoDatabase
        case .analysis:
            return .infoAnalysis
        case .users:
            return .infoUsers
        case .street:
            return .infoStreetMatch
        case .meet:
            return .infoMeetApp
        case .experts:
            return .infoExperts
        case .cards:
            return .infoCards
        default://wallet
            return .infoWallet
        }
    }
}
