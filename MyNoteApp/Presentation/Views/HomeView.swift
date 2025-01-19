//
//  HomeView.swift
//  MyNoteApp
//
//  Created by stewart rio on 17/01/25.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var sessionManager: SessionManager
    @StateObject var viewModel: AuthViewModel

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                VStack {
                    // Header
                    HStack {
                        //                    VStack(alignment: .leading, spacing: 8) {
                        //                        Text("Welcome,")
                        //                            .font(.headline)
                        //                        Text("Test")
                        //                            .font(.title)
                        //                            .fontWeight(.medium)
                        //                    }
                        //                    .padding(.horizontal)
                        
                        Spacer()
                        
                        NavigationLink(destination: SignUpView(viewModel: viewModel, sessionManager: SessionManager())) {
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    
                    // Main Navigation Buttons
                    VStack(spacing: 20) {
                        NavigationLink(destination: SignUpView(viewModel: viewModel, sessionManager: SessionManager())) {
                            HomeButtonView(
                                title: "Catatan Saya",
                                icon: "note.text"
                            )
                        }
                        
                        NavigationLink(destination: SignUpView(viewModel: viewModel, sessionManager: SessionManager())) {
                            HomeButtonView(title: "Tambah Catatan", icon: "plus.circle")
                        }
                    }
                    .padding(.vertical)
                    
                    Spacer()
                    
                }
                .navigationTitle("")
                .navigationBarHidden(true)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// Custom Views for Home Buttons
struct HomeButtonView: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 40, height: 40)
                .background(Color.blue.opacity(0.2))
                .clipShape(Circle())
                .foregroundColor(.blue)
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

// Custom View for Statistics
struct StatisticItemView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(value)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(sessionManager: SessionManager(), viewModel: AuthViewModel(signUpUseCase: SignUpUseCase(repository: AuthRepository()), loginUseCase: LoginUseCase(repository: AuthRepository())))
    }
}
