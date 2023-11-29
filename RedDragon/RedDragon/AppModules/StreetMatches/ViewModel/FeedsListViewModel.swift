//
//  FeedsListViewModel.swift
//  RedDragon
//
//  Created by Remya on 11/28/23.
//

import Foundation

class FeedsListViewModel: APIServiceManager<[StreetEvent]> {
    //function to fetch home data
    func fetchFeedsListAsyncCall() {
        let urlString   = URLConstants.eventsList
        let method      = RequestType.get
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}
