//
//  Translation.swift
//  RedDragon
//
//  Created by Abdullah on 22/12/2023.
//

import UIKit

final class Translation: APIServiceManager<TranslationModel> {
    static let shared = Translation()
    let service: TranslationService
    let request: TranslationRequest
    var model: TranslationModel!
    
    init(
        request: TranslationRequest = TranslationRequest(),
        service: TranslationService = RemoteTranslationService()
    ) {
        self.request = request
        self.service = service
    }
    
    func setupTranslationModule(completion: @escaping () -> Void) {
        fetchTranslationFromAPI {
            completion()
        }
    }
    
    func getTranslation(for string: String) -> String {
        if let _ = model {
            return self.filterArrayFor(string: string)
        }
        
        return string
    }
    
}

extension Translation {
    
    private func filterArrayFor(string: String) -> String {
        let finalString = model.translations?.first(where: {$0.key?.lowercased() == string.lowercased()})?.translationCN ?? string
        
        return finalString
    }

    private func fetchTranslationFromAPI(completion: @escaping () -> Void) {
        self.service.loadTranslation(request: request) { response in
            switch response {
            case .success(let model):
                self.model = model
                completion()

            case .failure(let error):
                print("Translation data fetching failed.Reason:", error.description)
                break
            }
        }
    }
    
//    private func saveTranslationsToCoreData(translations: [TranslationModel]) {
//        // Implement Core Data save logic
//    }
//    
//    private func fetchTranslationsFromCoreData() -> [TranslationModel] {
//        // Implement Core Data fetch logic
//        
//        return []
//    }

}
