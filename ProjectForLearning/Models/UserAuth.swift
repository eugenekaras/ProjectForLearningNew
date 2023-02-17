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
    
    @Published var user: User?
    @Published var state: SignInState = .unknown
    
    @MainActor
    func checkUser() async throws {
        guard let user = Auth.auth().currentUser else {
            self.user = nil
            self.state = .signedOut
            return
        }
        if let restoredUser = try await User(userId: user.uid) {
            self.user = restoredUser
        } else {
            self.user = User(
                userId: user.uid,
                email: user.email,
                displayName: user.displayName,
                phoneNumber: user.phoneNumber,
                url: user.photoURL)
            try await self.user?.saveUserData()
        }
        self.state = .signedIn
    }
    
    @MainActor
    private func getCredential() async throws -> AuthCredential {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("Firebase SDK is not integrated properly")
        }
        let configuration = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = configuration
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            fatalError("Error getting UIWindowScene")
        }
        guard let rootViewController = windowScene.windows.first?.rootViewController else {
            fatalError("Error getting rootViewController")
        }
        let signResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
        
        let accessToken = signResult.user.accessToken
        guard let idToken = signResult.user.idToken else {
            fatalError("Error getting idToken")
        }
        return GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
    }
    
    func signInAnonymously() async throws {
        try await Auth.auth().signInAnonymously()
        try await checkUser()
    }
    
    func signIn() async throws {
        let credential = try await getCredential()
        try await Auth.auth().signIn(with: credential)
        try await checkUser()
    }
    
    func reauthenticate() async throws {
        guard let user = Auth.auth().currentUser else {
            fatalError("Error re-authenticate a user")
        }
        let credential = try await getCredential()
        try await user.reauthenticate(with: credential)
    }
    
    func signOut() async throws {
        let firebaseAuth = Auth.auth()
        try firebaseAuth.signOut()
        try await checkUser()
    }
    
    func deleteUser() async throws {
        guard let user = Auth.auth().currentUser else {
            fatalError("Error getting current user for delete")
        }
        try await user.delete()
        try await checkUser()
    }
}

