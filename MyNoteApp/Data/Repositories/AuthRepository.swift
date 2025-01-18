//
//  AuthRepository.swift
//  MyNoteApp
//
//  Created by stewart rio on 17/01/25.
//

import Foundation
import FirebaseAuth

protocol AuthRepositoryProtocol {
    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
    func sendEmailVerification(to user: User, completion: @escaping (Error?) -> Void)
    func resendVerificationEmail(completion: @escaping (Result<Void, Error>) -> Void)
}

class AuthRepository: AuthRepositoryProtocol {
    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = authResult?.user {
                self.sendEmailVerification(to: user) { emailError in
                    if let emailError = emailError {
                        print("Failed to send verification email: \(emailError.localizedDescription)")
                    }
                }
                completion(.success(user))
            }
        }
    }

    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = authResult?.user {
                completion(.success(user))
            }
        }
    }
    
    func sendEmailVerification(to user: User, completion: @escaping (Error?) -> Void) {
        user.sendEmailVerification { error in
            completion(error)
        }
    }

    func resendVerificationEmail(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "No user is currently logged in."])))
            return
        }
        
        currentUser.sendEmailVerification { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
