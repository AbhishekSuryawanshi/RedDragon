//
//  ReportOrBlockUserViewModel.swift
//  RedDragon
//
//  Created by iOS Dev on 04/01/2024.
//

import Foundation

class BlockUserViewModel: APIServiceManager<BasicAPIResponse> {
    
    ///function to block user
    func postBlockUserAsyncCall(parameters: [String: Any]) {
        let urlString   = URLConstants.blockUser
        let method      = RequestType.post
        asyncCall(urlString: urlString, method: method, parameters: parameters)
    }
}

class ReportUserViewModel: APIServiceManager<BasicAPIResponse> {
    
    ///function to block user
    func postReportUserAsyncCall(parameters: [String: Any]) {
        let urlString   = URLConstants.reportUser
        let method      = RequestType.post
        asyncCall(urlString: urlString, method: method, parameters: parameters)
    }
}
