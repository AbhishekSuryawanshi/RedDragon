//
//  TranslationModel.swift
//  RedDragon
//
//  Created by Abdullah on 22/12/2023.
//

import Foundation

// MARK: - TranslationModel
struct TranslationModel: Codable {
    let translations: [TranslationDetails]?
}

// MARK: - Translation
struct TranslationDetails: Codable {
    let key, translationCN: String?

    enum CodingKeys: String, CodingKey {
        case key
        case translationCN = "translationCn"
    }
}

