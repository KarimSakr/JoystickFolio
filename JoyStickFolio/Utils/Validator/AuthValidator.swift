//
//  AuthValidator.swift
//  JoyStickFolio
//
//  Created by Karim Sakr on 05/12/2023.
//

import Foundation

class AuthValidator {
    
    func isFullNameValid(textField: String) -> Bool {
        let regex = "^[a-zA-Z0-9!@#$%^&*()_+{}\\[\\]:;<>,.?/~\\\\\\s-]{4,15}$"
           let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
           return predicate.evaluate(with: textField)
    }
    
    func isEmailValid(textField: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
           let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
           return predicate.evaluate(with: textField)
    }
    
    func isUsernameValid(textField: String) -> Bool {
        let regex = #"^[a-zA-Z0-9!@#$%^&*()_+{}\[\]:;<>,.?/~\\-]{4,20}$"#
           let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
           return predicate.evaluate(with: textField)
    }
    
    func isPasswordValid(textfield: String, repearTextField: String) -> Bool {
        return textfield == repearTextField && textfield.count >= 6
    }
}