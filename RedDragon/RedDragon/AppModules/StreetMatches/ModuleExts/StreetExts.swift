//
//  StreetExts.swift
//  RedDragon
//
//  Created by Remya on 12/18/23.
//

import Foundation
import UIKit

extension UIViewController{
    func isUserStreetProfileUpdated()->Bool{
        if UserDefaults.standard.user?.streetPlayerUpdated == 0{
            return false
        }
        else{
            return true
        }
    }
    
}

