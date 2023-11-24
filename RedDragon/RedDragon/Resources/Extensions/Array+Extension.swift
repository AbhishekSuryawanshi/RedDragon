//
//  Array+Extension.swift
//  RedDragon
//
//  Created by Qasr01 on 24/11/2023.
//

import Foundation

extension Array {
    
    func uniques<T: Hashable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        return reduce([]) { result, element in
            let alreadyExists = (result.contains(where: { $0[keyPath: keyPath] == element[keyPath: keyPath] }))
            return alreadyExists ? result : result + [element]
        }
    }
}
