//
//  AppDelegate+Extension.swift
//  RedDragon
//
//  Created by Remya on 12/19/23.
//

import Foundation

extension AppDelegate{
    func setupLanguage(){
        /// Check user's preffered language
        if let language = UserDefaults.standard.user?.language {
            UserDefaults.standard.language = language
        } else {
            /// if language key empty, take device language
            if let lastLannguage = UserDefaults.standard.language, lastLannguage != "" {
                
            } else {
                var lang = DeviceLanguage.currentLanguage()
                if lang.contains("zh") {
                    lang = "zh" //"zh-Hans"
                } else {
                    lang = "en"
                }
                UserDefaults.standard.language = lang
            }
        }
    }
}


