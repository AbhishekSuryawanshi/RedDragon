//
//  Validations.swift
//  RedDragon
//
//  Created by QASR02 on 23/10/2023.
//

import UIKit

extension UIViewController {
    
    public func isValidEmail(validate email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    public func isValidName(validate name: String) -> Bool {
        let nameRegex = "^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return namePredicate.evaluate(with: name)
    }
    
    public func isValidPassword(validate password: String) -> Bool {
        let minLength = 8
        let maxLength = 20
        
        if password.count < minLength || password.count > maxLength {
            return false
        }
        
        let uppercaseLetterRegex = ".*[A-Z]+.*"
        let uppercaseLetterPredicate = NSPredicate(format: "SELF MATCHES %@", uppercaseLetterRegex)
        guard uppercaseLetterPredicate.evaluate(with: password) else {
            return false
        }
        
        let lowercaseLetterRegex = ".*[a-z]+.*"
        let lowercaseLetterPredicate = NSPredicate(format: "SELF MATCHES %@", lowercaseLetterRegex)
        guard lowercaseLetterPredicate.evaluate(with: password) else {
            return false
        }
        
        let digitRegex = ".*\\d+.*"
        let digitPredicate = NSPredicate(format: "SELF MATCHES %@", digitRegex)
        guard digitPredicate.evaluate(with: password) else {
            return false
        }
        
        let specialCharacterRegex = ".*[!@#$%^&*()_+=\\-\\[\\]{};':\"\\\\|,.<>\\/?]+.*"
        let specialCharacterPredicate = NSPredicate(format: "SELF MATCHES %@", specialCharacterRegex)
        guard specialCharacterPredicate.evaluate(with: password) else {
            return false
        }
        
        return true
    }
    
}
