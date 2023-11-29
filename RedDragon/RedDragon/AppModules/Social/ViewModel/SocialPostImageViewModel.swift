//
//  SocialPostImageViewModel.swift
//  RedDragon
//
//  Created by Qasr01 on 21/11/2023.
//

import Foundation

class SocialPostImageVM: MultipartAPIServiceManager<SocialPostImageResponse> {
    init () {}
    static let shared = SocialPostImageVM()
    
    ///function to upload image for a post for social module
    func uploadImageAsyncCall(imageName: String, imageData: Data) {
        let urlString   = URLConstants.postImage
        asyncCall(urlString: urlString, params: nil, imageName: imageName, imageData: imageData)
    }
}
