//
//  StadiumListViewModel.swift
//  RedDragon
//
//  Created by Remya on 11/28/23.
//

import Foundation

class StadiumListViewModel: APIServiceManager<StreetStradiumListingResponse> {
    
    //function to fetch Stadium list
    func fetchStadiumListAsyncCall() {
        let urlString   = URLConstants.stadiumList
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
    
}
