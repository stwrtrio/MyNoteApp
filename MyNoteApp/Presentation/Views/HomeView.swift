//
//  HomeView.swift
//  MyNoteApp
//
//  Created by stewart rio on 17/01/25.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var sessionManager: SessionManager
    @State private var showLogoutConfirmation = false

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                        
                        Text("Welcome, \(sessionManager.currentUser?.email ?? "User")")
                            .font(.system(size: 16)) // Sesuaikan ukuran teks
                            .fontWeight(.light)
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                    
                    Spacer()
                    
                    // Tombol Logout
                    Button(action: {
                        showLogoutConfirmation = true
                    }) {
                        Image(systemName: "arrow.right.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                    }
                    .alert(isPresented: $showLogoutConfirmation) {
                        Alert(
                            title: Text("Logout Confirmation"),
                            message: Text("Are you sure you want to log out?"),
                            primaryButton: .destructive(Text("Logout")) {
                                sessionManager.signOut()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                    .padding()
                }
                .padding()
                
                Spacer()
            }
            .padding()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(sessionManager: SessionManager())
    }
}
