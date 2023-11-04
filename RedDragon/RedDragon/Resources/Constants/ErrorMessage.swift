//
//  ErrorMessage.swift
//  RedDragon
//
//  Created by QASR02 on 23/10/2023.
//

import Foundation

struct ErrorMessage {
    static let error                    = "Error"
    static let alert                    = "Alert"
    static let dismiss                  = "Dismiss"
    static let success                  = "Success"
    static let invalidName              = "Invalid name"
    static let invalidEmail             = "Invalid email"
    static let incorrectPassword        = "Incorrect password"
    static let passwordCondition        = "Password must have more than 8 characters and should contain at least 1 Uppercase letter, 1 Lowercase letter, 1 number and 1 Special character"
    static let dataNotFound             = "Data not found"
    static let networkAlert             = "No network connection!"
    static let somethingWentWrong       = "Something went wrong, please try again"
    static let responseFailed           = "response failed with other than error code"
    static let profileUpdated           = "Profile Updated."
    static let loginRequires            = "The App requires login"
    static var photoMinCountAlert       = "Alert! Photo count should be at least 1"
    static var photoMaxCountAlert       = "You've already reached the limit of 5 photos"
    
    static var chatEmptyAlert           = "No Chats yet!"
    static var likeListEmptyAlert       = "No Likes yet!"
    static var commentListEmptyAlert    = "No Comments yet!"
    static var leaguesEmptyAlert        = "No Leagues found"
    static var teamEmptyAlert           = "No Teams found"
    static var matchEmptyAlert          = "No Matches found"
}
