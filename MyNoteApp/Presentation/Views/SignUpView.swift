//
//  SignUpView.swift
//  MyNoteApp
//
//  Created by stewart rio on 17/01/25.
//

import SwiftUI

struct SignUpView: View {
    @StateObject var viewModel: AuthViewModel
    @ObservedObject var sessionManager: SessionManager
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isLoading = false
    @State private var isPasswordVisible: Bool = false
    @State private var isConfirmPasswordVisible: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Sign Up")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 30)
                
                // Email Field
                VStack(alignment: .leading, spacing: 10) {
                    Text("Email")
                        .foregroundColor(.white)
                        .font(.caption)
                    
                    TextField("Enter your email", text: $viewModel.email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
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
                            Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                    )
                }
                
                // Confirm Password Field
                VStack(alignment: .leading, spacing: 10) {
                    Text("Confirm Password")
                        .foregroundColor(.white)
                        .font(.caption)
                    
                    HStack {
                        if isConfirmPasswordVisible {
                            TextField("Re-enter your password", text: $confirmPassword)
                                .foregroundColor(.white)
                        } else {
                            SecureField("Re-enter your password", text: $confirmPassword)
                                .foregroundColor(.white)
                        }
                        
                        Button(action: {
                            isConfirmPasswordVisible.toggle()
                        }) {
                            Image(systemName: isConfirmPasswordVisible ? "eye" : "eye.slash")
                                .foregroundColor(.white)
                        }
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
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                if let successMessageSendEmailVerification = viewModel.successMessageSendEmailVerification {
                    Text(successMessageSendEmailVerification)
                        .foregroundColor(.green)
                        .font(.caption)
                }

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                // Sign-Up Button
                Button(action: {
                    signUp()
                }) {
                    HStack {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Sign Up")
                                .font(.headline)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(Color.purple)
                    .cornerRadius(10)
                }
                .padding(.top, 20)
                
                if viewModel.isSignedUp {
                    Button(action: {
                        viewModel.resendVerificationEmail()
                    }) {
                        HStack {
                            Text("Sign up successful! Please check your email for verification.")
                                .foregroundColor(.green)
                            
                            Text("Resend Verification Email")
                                .foregroundColor(.blue)
                                .underline()
                        }
                        .padding()
                    }
                }
            }
            .padding()
        }
    }
    
    private func signUp() {
        viewModel.signUp()
        sessionManager.isSigningUp = true
        
        // Validate inputs
        guard !viewModel.email.isEmpty, !viewModel.password.isEmpty, !confirmPassword.isEmpty else {
            showError = true
            errorMessage = "All fields are required."
            return
        }
        
        guard viewModel.password == confirmPassword else {
            showError = true
            errorMessage = "Passwords do not match."
            return
        }
        
        guard viewModel.password.count >= 6 else {
            showError = true
            errorMessage = "Password must be at least 6 characters."
            return
        }
        
        showError = false
        errorMessage = ""
        print("User signed up with email: \(viewModel.email)")
    }
}

#Preview {
    SignUpView(viewModel: AuthViewModel(signUpUseCase: SignUpUseCase(repository: AuthRepository()), loginUseCase: LoginUseCase(repository: AuthRepository())), sessionManager: SessionManager())
        .environmentObject(SessionManager())
}
