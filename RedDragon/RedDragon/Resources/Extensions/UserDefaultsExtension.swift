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
    
    var sport: String? {
        get {
            return value(forKey: UserDefaultString.sport) as? String
        }
        set {
            set(newValue, forKey: UserDefaultString.sport)
            synchronize()
        }
    }
    
    
    func clearSpecifiedItems() {
        removeObject(forKey: UserDefaultString.token)
        removeObject(forKey: UserDefaultString.language)
        synchronize()
    }
   
     var user: User? {
         get {
             if let decodedData = value(forKey: UserDefaultString.user) as? Data {
                 let decodedValue = try? JSONDecoder().decode(User.self, from: decodedData)
                 return decodedValue
             }
             return nil
         }
         set {
             if let value = newValue {
                 let encodedData = try? JSONEncoder().encode(value)
                 set(encodedData, forKey: UserDefaultString.user)
                 synchronize()
             }
         }
     }
     
}


