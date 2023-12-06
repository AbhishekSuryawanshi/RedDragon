//
//  StreetImageUploadViewModel.swift
//  RedDragon
//
//  Created by Remya on 12/5/23.
//

import Foundation


class StreetImageUploadViewModel: MultipartAPIServiceManager<UploadResponse> {
    static let shared = StreetImageUploadViewModel()
    
    //function to upload image
    func uploadStreetImageAsyncCall(imageName: String, imageData: Data) {
        let urlString   = URLConstants.streetUploadImage
        asyncCall(urlString: urlString, params: nil, imageName: imageName, imageData: imageData, imageKey: imageName)
    }
    
}
