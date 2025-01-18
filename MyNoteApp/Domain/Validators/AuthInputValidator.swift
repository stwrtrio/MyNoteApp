//
//  AuthInputValidator.swift
//  MyNoteApp
//
//  Created by stewart rio on 17/01/25.
//

import Foundation

class AuthInputValidator {
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }

    static func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
}
