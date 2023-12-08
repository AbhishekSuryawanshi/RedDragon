//
//  PlaceBetViewModel.swift
//  RedDragon
//
//  Created by Qoo on 22/11/2023.
//

import Foundation

class PlaceBetViewModel : APIServiceManager<BetSuccessModel> {
    
    // function to place bet
    func placeBet(oddIndex : String, betAmount : String, slug : String, day : String){
        var myTime : Date?
        
        if day == "today"{
            myTime = Date.today
        }else{
            myTime = Date.tomorrow
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: myTime!)
        
        
        let params = [
            "date" : date,
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
