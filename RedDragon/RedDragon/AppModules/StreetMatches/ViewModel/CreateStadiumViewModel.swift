//
//  CreateStadiumViewModel.swift
//  RedDragon
//
//  Created by Remya on 12/5/23.
//

import Foundation

class CreateStadiumViewModel: APIServiceManager<StreetGeneralResponse> {
    
    var timings = [LocalTimings]()
    var sportTypes:[SportTypes] = [.Football,.Basketball,.Tennis,.Cricket]
    var amenities:[Amenities] = [.Parking,.Restrooms,.Drinks]
    var selectedAmenities = [Amenities]()
    var selectedSportTypes = [SportTypes]()
    var imagePaths = [String]()
    
    func populateTimings(){
        let days = ["Sunday".localized,"Monday".localized,"Tuesday".localized,"Wednesday".localized,"Thursday".localized,"Friday".localized,"Saturday".localized]
        for m in days{
            let obj = LocalTimings(day: m, from: "", to: "")
            timings.append(obj)
        }
    }
    
    func checkEmptyTimings()->Bool{
        if timings.filter({$0.from == "" || $0.to == ""}).count > 0{
            return false
        }
        else{
            return true
        }
    }
    
    //function to create stadium
    func cretaeStadiumAsyncCall(parameters:[String:Any]) {
        let urlString   = URLConstants.stadiums
        let method      = RequestType.post
        asyncCall(urlString: urlString, method: method, parameters: parameters)
    }
    
}
