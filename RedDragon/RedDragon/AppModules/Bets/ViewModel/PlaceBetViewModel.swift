//
//  PlaceBetViewModel.swift
//  RedDragon
//
//  Created by Qoo on 22/11/2023.
//

import Foundation

class PlaceBetViewModel : APIServiceManager<BetSuccessModel> {
    
    // function to place bet
    func placeBet(oddIndex : String, betAmount : String, slug : String){
        
        // get today date
        let myTime = Date.today
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todaysDate = dateFormatter.string(from: myTime)
        
        let params = [
            "session" : DefaultToken.session,
            "date" : todaysDate,
            "sport" : UserDefaults.standard.sport ?? "football",
            "slug" : slug,
            "odd_index" : oddIndex,
            "amount" : betAmount
        ]
        
        let urlString   = URLConstants.placeBet
        let method      = RequestType.post
        
        asyncCall(urlString: urlString, method: method, parameters: params)
    }
}
