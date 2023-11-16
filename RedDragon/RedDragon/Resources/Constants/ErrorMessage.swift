//
//  ErrorMessage.swift
//  RedDragon
//
//  Created by QASR02 on 23/10/2023.
//

import Foundation

struct ErrorMessage {
    static let error                       = "Error"
    static let alert                       = "Alert"
    static let dismiss                     = "Dismiss"
    static let success                     = "Success"
    static let invalidName                 = "Invalid name"
    static let invalidEmail                = "Invalid email"
    static let invalidPhone                = "Invalid phone number"
    static let incorrectPassword           = "Incorrect password"
    static let passwordCondition           = "Password must have more than 8 characters and should contain at least 1 Uppercase letter, 1 Lowercase letter, 1 number and 1 Special character"
    static var emailEmptyAlert             = "Please enter your email"
    static var nameEmptyAlert              = "Please enter your full name"
    static var userNameEmptyAlert          = "Please enter your user name"
    static var phoneEmptyAlert             = "Please enter your phone number"
    static var passwordEmptyAlert          = "Please enter a password"
    static var confirmPasswordEmptyAlert   = "Please confirm your password"
    static var termsAlert                  = "Confirm your acceptance of the terms and conditions"
    static var passwordNotmatchedAlert     = "Passwords do not match"
    static var otpEmptyAlert               = "Enter verification Code"
    static let dataNotFound                = "Data not found"
    static let networkAlert                = "No network connection!"
    static let somethingWentWrong          = "Something went wrong, please try again"
    static let responseFailed              = "response failed with other than error code"
    static let profileUpdated              = "Profile Updated."
    static let loginRequires               = "The App requires login"
    static var photoMinCountAlert          = "Alert! Photo count should be at least 1"
    static var photoMaxCountAlert          = "You've already reached the limit of 5 photos"
    static var textEmptyAlert              = "What do you want to talk about?"
    static var pollOptionEmptyAlert        = "Please add two poll choices"
    
    static var chatEmptyAlert              = "No Chats yet!"
    static var likeListEmptyAlert          = "No Likes yet!"
    static var commentListEmptyAlert       = "No Comments yet!"
    static var leaguesEmptyAlert           = "No Leagues found"
    static var teamEmptyAlert              = "No Teams found"
    static var matchEmptyAlert             = "No Matches found"
}
