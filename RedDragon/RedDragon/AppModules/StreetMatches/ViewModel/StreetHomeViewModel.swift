//
//  StreetHomeViewModel.swift
//  RedDragon
//
//  Created by Remya on 11/24/23.
//

import Foundation

class StreetHomeViewModel: APIServiceManager<StreetMatchHome> {
    
    //function to fetch home data
    func fetchStreetHomeAsyncCall(id:Int?) {
        var urlString   = URLConstants.streetHome
        let method      = RequestType.get
        if id != nil{
            let queryItems = [
                URLQueryItem(name: "userId", value: String(id!))
            ]
            var urlComponents = URLComponents(string: urlString)
            urlComponents?.queryItems = queryItems
            urlString = urlComponents?.string ?? ""
        }
        asyncCall(urlString: urlString, method: method, parameters: nil)
    }
}
