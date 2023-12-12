//
//  UpdateMatchStatus.swift
//  RedDragon
//
//  Created by QASR02 on 12/12/2023.
//

import Foundation

class UpdateMatchStatus: APIServiceManager<ResponseMessage> {
    
    func yourMatchesAsyncCall(budget: Int, result: String, score: String, opponentUserID: Int, againstComputer: Bool) {
        let urlString = URLConstants.yourMatches
        let method = RequestType.post
        var parameters: [String: Any] = [:]
        if againstComputer {
            parameters = ["result": result, "budget": budget, "score": score]
        }
        else {
            parameters = ["result": result, "budget": budget, "score": score, "opponent_user_id": opponentUserID]
        }
        asyncCall(urlString: urlString, method: method, parameters: parameters, isGuestUser: true, anyDefaultToken: DefaultToken.guestUserCardGame)
    }
    
}
