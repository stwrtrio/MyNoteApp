//
//  LandingView.swift
//  MyNoteApp
//
//  Created by stewart rio on 17/01/25.
//

import SwiftUI

struct LandingView: View {
    @StateObject private var sessionManager = SessionManager()
    
    var body: some View {
        ZStack {
            VStack {
                if sessionManager.isSigningUp {
                    SignUpView(viewModel: AuthViewModel(
                        signUpUseCase: SignUpUseCase(repository: AuthRepository()),
                        loginUseCase: LoginUseCase(repository: AuthRepository())
                    ), sessionManager: SessionManager())
                    .environmentObject(sessionManager)
                } else if sessionManager.isAuthenticated {
                    HomeView(sessionManager: sessionManager, viewModel: AuthViewModel(
                        signUpUseCase: SignUpUseCase(repository: AuthRepository()),
                        loginUseCase: LoginUseCase(repository: AuthRepository())))
                        .transition(.opacity)
                        .animation(.easeInOut, value: sessionManager.isAuthenticated)
                } else {
                    LoginView(viewModel: AuthViewModel(
                        signUpUseCase: SignUpUseCase(repository: AuthRepository()),
                        loginUseCase: LoginUseCase(repository: AuthRepository())
                    ), sessionManager: sessionManager)
                    .navigationTitle("Login")
                    .navigationBarHidden(true)
                }
            }
            .onAppear {
                sessionManager.objectWillChange.send()
            }
        }
    }
}
