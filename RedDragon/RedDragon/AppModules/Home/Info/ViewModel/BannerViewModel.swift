//
//  BannerViewModel.swift
//  RedDragon
//
//  Created by QASR02 on 16/12/2023.
//

import Foundation

class BannerViewModel: APIServiceManager<Banners> {
    
    func fetchBannerDataAsyncCall() {
        let url = URLConstants.banners
        let method = RequestType.get
        asyncCall(urlString: url, method: method, parameters: nil)
    }
}
