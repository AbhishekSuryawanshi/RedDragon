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
    static let incorrectOTP                = "Incorrect verification code"
    static let passwordCondition           = "Password must have more than 8 characters and should contain at least 1 Uppercase letter, 1 Lowercase letter, 1 number and 1 Special character"
    static var emailEmptyAlert             = "Please enter your email"
    static var nameEmptyAlert              = "Please enter your full name"
    static var userNameEmptyAlert          = "Please enter your user name"
    static var phoneEmptyAlert             = "Please enter your phone number"
    static var passwordEmptyAlert          = "Please enter a password"
    static var amountEmptyAlert            = "Please enter amount first"
    static var onlyLiveMatches             = "Bet can not be placed"
    static var oddsEmptyAlert              = "Please choose odds first"
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
    static var betsEmptyAlert              = "No Bets found"
    
    static let addPlayer                   = "Looks like you haven't bought any players yet, please buy a player to play the game"
    static let noPlayers                   = "Currently, this user has no players"
    static let playerListUnavailable       = "Players list unavailable"
    static let userIDNotFound              = "Unable to get user ID"
    static let lowBudget                   = "Low Budget"
    static let insufficientBudget          = "Sorry, you don't have sufficient budget to buy this player"
    static let addPlayerToPlay             = "In order to play the game, you must have at least 11 players"
    static let playerAlreadyUsed           = "Your team already has this player"
    static let playerBuyed                 = "Player bought successfully!!"
    static let playerRemoved               = "Player removed!!"
    static let matchDraw                   = "Match Draw!!"
    static let sameScore                   = "Both users scored same score"
    static let wellPlayed                  = "Well Played!!"
    
    static let betPlacedSuccess            = "Bet Placed Successfully"
    static let betPlacedAlready            = "Bet Already Placed"
    
    static let eventTitleEmptyAlert        = "Please enter event title"
    static let eventDescEmptyAlert         = "Please enter event description"
    static let eventImageEmptyAlert        = "Please enter event image"
    static let eventStartDateEmptyAlert    = "Please enter event start date"
    static let eventStartTimeEmptyAlert    = "Please enter event start time"
    static let eventLocationEmptyAlert     = "Please enter event location"
    static let eventPriceEmptyAlert        = "Please enter event location"
    
    static let bannerNotFound              = "Banner data not found"
    static let liveMatchNotFound           = "Live matches are not available at this moment."
    static let whatsHappeningNotFound      = "Data not found for What's Happening section"
    static let predictionsNotFound         = "Predictions data not available"
}

struct SuccessMessage {
    static let successfullyLikedUser       = "User liked successfully"
}
