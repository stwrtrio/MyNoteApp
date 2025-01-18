//
//  ViewAuthModel.swift
//  MyNoteApp
//
//  Created by stewart rio on 17/01/25.
//

import Foundation

import Combine
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var isAuthenticated: Bool = false
    @Published var signOut: Bool = false
    @Published var successMessageSendEmailVerification: String?
    @Published var isSignedUp: Bool = false

    private let signUpUseCase: SignUpUseCase
    private let loginUseCase: LoginUseCase

    init(signUpUseCase: SignUpUseCase, loginUseCase: LoginUseCase) {
        self.signUpUseCase = signUpUseCase
        self.loginUseCase = loginUseCase
    }

    // Fungsi untuk memvalidasi input
    func validateInputs() -> Bool {
        if !AuthInputValidator.isValidEmail(email) {
            errorMessage = "Email tidak valid"
            return false
        }
        
        if !AuthInputValidator.isValidPassword(password) {
            errorMessage = "Password harus memiliki minimal 6 karakter"
            return false
        }
        
        errorMessage = nil
        return true
    }

    func signUp() {
        guard validateInputs() else { return }
        
        signUpUseCase.execute(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.isSignedUp = true
                    self?.errorMessage = "Verification email sent to \(user.email ?? "your email address"). Please verify to log in."
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func login() {
        guard validateInputs() else { return }
        
        loginUseCase.execute(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    if user.isEmailVerified {
                        self?.isAuthenticated = true
                    } else {
                        self?.isAuthenticated = false
                        self?.errorMessage = "Please verify your email before logging in."
                        self?.signOut = true
                    }
                case .failure(let error):
                    print("Error: \(error)")
                    self?.isAuthenticated = false
                    self?.errorMessage = self?.getErrorMessage(from: error)
                }
            }
        }
    }
    
    func resendVerificationEmail() {
        signUpUseCase.resendEmailVerification { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.successMessageSendEmailVerification = "Verification email has been sent. Please check your inbox."
                case .failure(let error):
                    self?.errorMessage = self?.getErrorMessage(from: error)
                }
            }
        }
    }
    
    func getErrorMessage(from error: Error) -> String {
        let nsError = error as NSError
        if let underlyingErrors = nsError.underlyingErrors as? [NSError] {
            for underlyingError in underlyingErrors {
                if let nsUnderlyingError = underlyingError as? NSError,
                   let userInfo = nsUnderlyingError.userInfo["FIRAuthErrorUserInfoDeserializedResponseKey"] as? [String: Any],
                   let errMessage = userInfo["message"] as? String {
                    switch errMessage {
                    case "INVALID_LOGIN_CREDENTIALS":
                        return "The email or password you entered is incorrect. Please try again."
                    case "EMAIL_NOT_VERIFIED":
                        return "Your email is not verified. Please check your inbox and verify your email."
                    case "USER_DISABLED":
                        return "Your account has been disabled. Please contact support for assistance."
                    default:
                        return "An unexpected error occurred: \(errMessage)"
                    }
                }
            }
        }
        
        // Mapping pesan error umum
        switch nsError.code {
        case AuthErrorCode.invalidEmail.rawValue:
            return "The email address is badly formatted."
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return "The email address is already in use by another account."
        case AuthErrorCode.userNotFound.rawValue:
            return "There is no user record corresponding to this identifier."
        case AuthErrorCode.networkError.rawValue:
            return "A network error occurred. Please check your connection."
        case AuthErrorCode.userDisabled.rawValue:
            return "The user account has been disabled by an administrator."
        case AuthErrorCode.weakPassword.rawValue:
            return "The password must be 6 characters long or more."
        default:
            print("here")
            return nsError.localizedDescription
        }
    }

//    private func getErrorMessage(from error: Error) -> String {
//        let errorCode = (error as NSError).code
//        let errorDomain = (error as NSError).domain
//
//        guard errorDomain == "FIRAuthErrorDomain" else {
//            return "An unknown error occurred. Please try again."
//        }
//
//        switch errorCode {
//        case AuthErrorCode.invalidEmail.rawValue:
//            return "The email address is badly formatted."
//        case AuthErrorCode.wrongPassword.rawValue:
//            return "The password is invalid or the user does not have a password."
//        case AuthErrorCode.emailAlreadyInUse.rawValue:
//            return "The email address is already in use by another account."
//        case AuthErrorCode.userNotFound.rawValue:
//            return "There is no user record corresponding to this identifier."
//        case AuthErrorCode.networkError.rawValue:
//            return "A network error occurred. Please check your connection."
//        case AuthErrorCode.userDisabled.rawValue:
//            return "The user account has been disabled by an administrator."
//        case AuthErrorCode.weakPassword.rawValue:
//            return "The password must be 6 characters long or more."
//        default:
//            return "An internal error occurred. Please try again later."
//        }
//    }
}
