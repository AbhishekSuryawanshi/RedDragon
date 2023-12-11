//
//  StreetHomeViewModel.swift
//  RedDragon
//
//  Created by Remya on 11/24/23.
//

import Foundation

class StreetHomeViewModel: APIServiceManager<StreetMatchHome> {
    
    //function to fetch home data
    func fetchStreetHomeAsyncCall() {
        let urlString   = URLConstants.streetHome
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}
