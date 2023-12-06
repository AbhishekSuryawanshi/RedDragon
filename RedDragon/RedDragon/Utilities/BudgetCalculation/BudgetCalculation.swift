//
//  BudgetCalculation.swift
//  RedDragon
//
//  Created by QASR02 on 06/12/2023.
//

import Foundation

class BudgetCalculation {
    
    func performOperation<T: Numeric>(_ operand1: T, _ operand2: T, operation: (T, T) -> T ) -> T {
        return operation(operand1, operand2)
    }
    
}
