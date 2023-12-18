//
//  StreetPlayersListViewModel.swift
//  RedDragon
//
//  Created by Remya on 12/9/23.
//

import Foundation

class StreetPlayersListViewModel: APIServiceManager<StreetPlayersListResponse> {
    
    //function to fetch player list
    func fetchStreetPlayerListAsyncCall() {
        let urlString   = URLConstants.streetPlayersList
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
    
}
