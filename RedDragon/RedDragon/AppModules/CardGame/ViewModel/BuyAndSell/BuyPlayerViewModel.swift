//
//  BuyPlayerViewModel.swift
//  RedDragon
//
//  Created by QASR02 on 06/12/2023.
//

import Foundation

class BuyPlayerViewModel : APIServiceManager<ResponseMessage> {
    
    func buyPlayerAsyncData(id: Int,
                            name: String,
                            position: String,
                            marketValue: String,
                            img_url: String)
    {
        let url = URLConstants.cardGame_buyPlayer
        let method = RequestType.put
        
        let player: [String: Any] = [
            "id": id,
            "name": name,
            "position": position,
            "market_value": marketValue,
            "img_url": img_url
        ]
        let parameters: [String: Any] = [
            "players": [player]
        ]
        
        asyncCall(urlString: url, method: method, parameters: parameters, isGuestUser: true, anyDefaultToken: DefaultToken.guestUserCardGame)
    }
    
}
