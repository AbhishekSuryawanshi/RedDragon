//
//  UpdateInfoViewModel.swift
//  RedDragon
//
//  Created by QASR02 on 06/12/2023.
//

import Foundation

class UpdateInfoViewModel: APIServiceManager<ResponseMessage> {
    
    //Budget
    func updateBudgetAsyncCall(budget: Int) {
        let urlString = URLConstants.updateUserInfo
        let method = RequestType.put
        let parameters: [String: Any] = ["budget": budget]
        asyncCall(urlString: urlString, method: method, parameters: parameters, isGuestUser: true, anyDefaultToken: DefaultToken.guestUserCardGame)
    }
    
    //score
    func updateScoreAsyncCall(score: Int) {
        let urlString = URLConstants.updateUserInfo
        let method = RequestType.put
        let parameters: [String: Any] = ["score": score]
        asyncCall(urlString: urlString, method: method, parameters: parameters, isGuestUser: true, anyDefaultToken: DefaultToken.guestUserCardGame)
    }
    
}
