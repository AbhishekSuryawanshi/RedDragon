//
//  TrendingCollectionCellViewModel.swift
//  RedDragon
//
//  Created by Abdullah on 09/12/2023.
//

import Foundation

enum TrendingCollectionSection {
    case list([NewsDetail])
    
    var data: [NewsDetail] {
        switch self {
        case .list(let model):
            return model.count > 0 ? model : []
        }
    }
}

final class TrendingCollectionCellViewModel {

    let model: [NewsDetail]
    var section: [TrendingCollectionSection] = []
    
    init(model: [NewsDetail]) {
        self.model = model
        setSection()
    }
    
    func setSection() {
        self.section = [
            TrendingCollectionSection.list(Array(self.model[0..<3])),
            TrendingCollectionSection.list(Array(self.model[3..<6])),
            TrendingCollectionSection.list(Array(self.model[6..<9]))
        ]
    }

}

