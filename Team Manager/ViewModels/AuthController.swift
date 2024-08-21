//
//  AuthController.swift
//  Team Manager
//
//  Created by Michael Gibson on 8/21/24.
//

import SwiftUI
import FirebaseAuth
import Combine

enum AuthState {
    case undefined, authenticated, notAuthenticated
}

class AuthController: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var authState: AuthState = .undefined
    
    init() {
            listenToAuthChanges()
        }
    
    func listenToAuthChanges() {
        Auth.auth().addStateDidChangeListener { auth, user in
            self.authState = user != nil ? .authenticated : .notAuthenticated
        }
    }
    
    // Authentication Logic
    func signUp() async throws {
        _ = try await Auth.auth().createUser(withEmail: email, password: password)
        print("\(email) signed up")
    }
    
    func signIn() async throws {
        _ = try await Auth.auth().signIn(withEmail: email, password: password)
        print("\(email) signed in")
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
        print("\(email) signed out")
    }
    
}
