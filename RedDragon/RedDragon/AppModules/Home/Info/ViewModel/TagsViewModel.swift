//
//  TagsViewModel.swift
//  RedDragon
//
//  Created by QASR02 on 18/12/2023.
//

import Foundation

class TagsViewModel: APIServiceManager<Tags> {
    
    func fetchTagsAsyncCall() {
        let url = URLConstants.tagsURL
        let method = RequestType.get
        asyncCall(urlString: url, method: method, parameters: nil)
    }
}
