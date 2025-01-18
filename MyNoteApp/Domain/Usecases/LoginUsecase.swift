//
//  LoginUsecase.swift
//  MyNoteApp
//
//  Created by stewart rio on 17/01/25.
//

import Foundation
import FirebaseAuth

class LoginUseCase {
    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func execute(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        repository.login(email: email, password: password, completion: completion)
    }
}
