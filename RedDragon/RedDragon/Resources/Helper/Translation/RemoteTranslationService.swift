//
//  RemoteTranslationService.swift
//  RedDragon
//
//  Created by Abdullah on 23/12/2023.
//

import Foundation

final class RemoteTranslationService: TranslationService {

    func loadTranslation(request: TranslationRequest, completion: @escaping Completion) {
        NetworkManager.loadData(request: request, parameters: request, completion: completion)
    }

}
