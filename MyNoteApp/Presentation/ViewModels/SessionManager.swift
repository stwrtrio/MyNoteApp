//
//  SessionManager.swift
//  MyNoteApp
//
//  Created by stewart rio on 17/01/25.
//

import Foundation
import FirebaseAuth
import Combine

class SessionManager: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var currentUser: User? = nil
    @Published var isSigningUp: Bool = false

    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?

    init() {
        self.authStateListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            if let user = user {
                // Pengguna berhasil login
                self?.isAuthenticated = true
                self?.currentUser = user
            } else {
                // Pengguna logout
                self?.isAuthenticated = false
                self?.currentUser = nil
            }
        }
    }

    deinit {
        // Hapus listener saat objek ini tidak lagi digunakan
        if let handle = authStateListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            // Setelah logout, status pengguna diubah
            self.isAuthenticated = false
            self.currentUser = nil
        } catch {
            print("Logout error: \(error.localizedDescription)")
        }
    }
}
