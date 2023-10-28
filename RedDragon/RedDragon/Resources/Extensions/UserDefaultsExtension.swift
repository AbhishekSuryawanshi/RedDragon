//
//  UserDefaultsExtension.swift
//  RedDragon
//
//  Created by Qasr01 on 28/10/2023.
//

import Foundation

extension UserDefaults {
   
    var token: String? {
        get {
            return value(forKey: UserDefaultString.token) as? String
        }
        set {
            set(newValue, forKey: UserDefaultString.token)
            synchronize()
        }
    }
    
    var language: String? {
        get {
            return value(forKey: UserDefaultString.language) as? String
        }
        set {
            set(newValue, forKey: UserDefaultString.language)
            synchronize()
        }
    }
    
    
    func clearSpecifiedItems() {
        removeObject(forKey: UserDefaultString.token)
        removeObject(forKey: UserDefaultString.language)
        synchronize()
    }
    
    /*
     var onbordingLoaded: Bool? {
         get {
             return value(forKey: .onbordingLoaded) as? Bool
         }
         set {
             set(newValue, forKey: .onbordingLoaded)
             synchronize()
         }
     }
     
     var user: PSUser? {
         get {
             if let decodedData = value(forKey: .user) as? Data {
                 let decodedValue = try? JSONDecoder().decode(PSUser.self, from: decodedData)
                 return decodedValue
             }
             return nil
         }
         set {
             if let value = newValue {
                 let encodedData = try? JSONEncoder().encode(value)
                 set(encodedData, forKey: .user)
                 synchronize()
             }
         }
     }
     
     extension String {
         static let token               = "token"
         static let user                = "user"
     }
     */
}


