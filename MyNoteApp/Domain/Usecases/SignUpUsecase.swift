//
//  SignUpUsecase.swift
//  MyNoteApp
//
//  Created by stewart rio on 17/01/25.
//

import Foundation
import FirebaseAuth

class SignUpUseCase {
    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func execute(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        repository.signUp(email: email, password: password, completion: completion)
    }
    
    func resendEmailVerification(completion: @escaping (Result<Void, Error>) -> Void) {
        repository.resendVerificationEmail(completion: completion)
    }
}
