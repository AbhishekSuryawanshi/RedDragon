//
//  CountriesViewModel.swift
//  RedDragon
//
//  Created by Qasr01 on 05/01/2024.
//

import Foundation

class CountryListVM: APIServiceManager<CountryListDataResponse> {
    
    static let shared = CountryListVM()
    
    var countryArray: [Country] = []
    
    ///function to get profile
    func getCountryListAsyncCall() {
        asyncCall(urlString: URLConstants.getcountries, method: .get, parameters: nil)
    }
}
