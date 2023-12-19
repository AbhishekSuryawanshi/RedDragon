//
//  AppDelegate+Extension.swift
//  RedDragon
//
//  Created by Remya on 12/19/23.
//

import Foundation

extension AppDelegate{
    func setupLanguage(){
        var lang = DeviceLanguage.currentLanguage()
        if lang.contains("zh"){
            lang = "zh-Hans"
        }
        else{
            lang = "en"
        }
        UserDefaults.standard.language = lang
    }
}
