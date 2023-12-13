//
//  StreetMatchesViewModel.swift
//  RedDragon
//
//  Created by Remya on 11/28/23.
//

import Foundation

class StreetMatchesViewModel: APIServiceManager<[StreetMatch]> {
    //function to fetch matches data
    func fetchMatchesListAsyncCall(offset:String) {
        var urlString   = URLConstants.streetMatchesList
        let method      = RequestType.get
        if offset != ""{
            let queryItems = [
                URLQueryItem(name: "dayOffsetFilter", value: offset)
            ]
            var urlComponents = URLComponents(string: urlString)
            urlComponents?.queryItems = queryItems
            urlString = urlComponents?.string ?? ""
        }
        
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}
