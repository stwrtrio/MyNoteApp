//
//  LoginView.swift
//  MyNoteApp
//
//  Created by stewart rio on 17/01/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible: Bool = false
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    @StateObject var sessionManager: SessionManager
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    // Header
                    VStack {
                        Text("Welcome Back!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Login to your account")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.bottom, 40)
                    
                    // Email Field
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Email")
                            .foregroundColor(.white)
                            .font(.caption)
                        
                        TextField("Enter your email", text: $viewModel.email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white.opacity(0.5), lineWidth: 1)
                            )
                    }
                    
                    // Password Field
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Password")
                            .foregroundColor(.white)
                            .font(.caption)
                        
                        HStack {
                            if isPasswordVisible {
                                TextField("Enter your password", text: $viewModel.password)
                                    .foregroundColor(.white)
                            } else {
                                SecureField("Enter your password", text: $viewModel.password)
                                    .foregroundColor(.white)
                            }
                            
                            Button(action: {
                                isPasswordVisible.toggle()
                            }) {
                                Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            .padding(.trailing, 10)
                        }
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white.opacity(0.5), lineWidth: 1)
                        )
                    }
                    
                    // Error Message
                    if showError {
                        Text(viewModel.errorMessage ?? "Unknown error")
                            .font(.footnote)
                            .foregroundColor(.red)
                            .padding(.top, 10)
                    }
                    
                    // Login Button
                    Button(action: {
                        loginUser()
                    }) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Login")
                                    .font(.headline)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(Color.purple)
                        .cornerRadius(10)
                    }
                    .disabled(isLoading)
                    
                    // Redirect to Sign Up
                    HStack {
                        Text("Don't have an account?")
                            .foregroundColor(.white)
                        
                        NavigationLink(destination: SignUpView(viewModel: viewModel, sessionManager: SessionManager())) {
                            Text("Register")
                                .foregroundColor(.indigo)
                                .fontWeight(.bold)
                        }
                    }
                    .padding(.top, 10)
                }
                .padding()
            }
        }
    }

    private func loginUser() {
        isLoading = true
        viewModel.login()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if viewModel.signOut {
                sessionManager.signOut()
            }
            self.isLoading = false
            if viewModel.isAuthenticated {
                self.showError = false
            } else {
                self.showError = true
                let errorMessage = viewModel.errorMessage
                self.errorMessage = errorMessage ?? ""
            }
            
            print("print err: \(errorMessage)")
        }
    }
}

#Preview {
    LoginView(viewModel: AuthViewModel(signUpUseCase: SignUpUseCase(repository: AuthRepository()), loginUseCase: LoginUseCase(repository: AuthRepository())), sessionManager: SessionManager())
        .environmentObject(SessionManager())
}
