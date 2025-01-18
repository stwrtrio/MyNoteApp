//
//  MyNoteAppApp.swift
//  MyNoteApp
//
//  Created by stewart rio on 17/01/25.
//

import SwiftUI
import Firebase

@main
struct MyNoteAppApp: App {
    @StateObject private var sessionManager = SessionManager()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            LandingView()
        }
    }
}
