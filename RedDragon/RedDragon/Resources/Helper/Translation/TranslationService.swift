//
//  TranslationService.swift
//  RedDragon
//
//  Created by Abdullah on 23/12/2023.
//

import Foundation

protocol TranslationService {
    typealias Completion = (Result<TranslationModel, CustomError>) -> Void
    
    func loadTranslation(request: TranslationRequest, completion: @escaping Completion)
}
