//
//  AuthenticationViewModel.swift
//  ProjectForLearning
//
//  Created by Евгений Карась on 21.01.23.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import Firebase
import FirebaseAuth
import Combine


class UserAuth: ObservableObject {
    
    enum SignInState {
        case unknown
        case signedIn
        case signedOut
    }
    
    @Published var session: User?
    @Published var state: SignInState =  .unknown
    
    func checkSignIn() {
        let user = Auth.auth().currentUser
        if let user = user {
            self.session =  User( userId: user.uid, email: user.email, displayName: user.displayName, url: user.photoURL)
            self.state = .signedIn
        } else {
            self.session = nil
            self.state = .signedOut
        }
    }
 
    func signIn() async throws {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let configuration = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = configuration
        
        guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let rootViewController = await windowScene.windows.first?.rootViewController else { return }
        
        let signResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
        try await authenticateUser(for: signResult.user)
    }
    
    func signInAnonymously() async throws {
        let authResult = try await Auth.auth().signInAnonymously()
        
        guard !authResult.user.uid.isEmpty else { return }
        
        self.session =  User( userId: authResult.user.uid,
                              email: authResult.user.email,
                              displayName: authResult.user.displayName,
                              url: authResult.user.photoURL)
        
        self.state = .signedIn
    }

    private func authenticateUser(for user: GIDGoogleUser?) async throws {
        guard let accessToken = user?.accessToken else { return }
        guard let idToken = user?.idToken else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
        let authResult =  try await Auth.auth().signIn(with: credential)
        
        guard !authResult.user.uid.isEmpty else { return }
        
        self.session =  User( userId: authResult.user.uid,
                              email: authResult.user.email,
                              displayName: authResult.user.displayName,
                              url: authResult.user.photoURL)
        
        self.state = .signedIn
    }
    
    func signOut() async throws {
        let firebaseAuth = Auth.auth()
        try firebaseAuth.signOut()
        state = .signedOut
        self.session = nil
    }
    
    func deleteUser()  async throws {
        let user = Auth.auth().currentUser
        try await user?.delete()
        try await self.signOut()
    }
}

