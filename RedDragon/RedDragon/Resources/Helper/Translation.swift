//
//  Translation.swift
//  RedDragon
//
//  Created by Abdullah on 22/12/2023.
//

import Foundation
import CoreData

final class Translation {
    static let shared = Translation()
    
    private init() {}
    
    func getTranslation(for key: String) -> String {
        // Logic to fetch translation from Core Data
        // If not found, call API and store in Core Data
        // Return translated string or original string
        
        return ""
    }
    
    private func fetchTranslationFromAPI() {
        // Use URLSession to make API request
        // Parse the response and store in Core Data
    }
    
    private func saveTranslationsToCoreData(translations: [TranslationModel]) {
        // Implement Core Data save logic
    }
    
    private func fetchTranslationsFromCoreData() -> [TranslationModel] {
        // Implement Core Data fetch logic
        
        return []
    }
}

//// Inside your app delegate or wherever appropriate
//func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//    if TranslationManager.shared.fetchTranslationsFromCoreData().isEmpty {
//        TranslationManager.shared.fetchTranslationFromAPI()
//    }
//    return true
//}
