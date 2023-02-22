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
    
    @Published var user: User = .emptyUser
    @Published var state: SignInState = .unknown
    
    @MainActor
    func checkUser() async throws {
        guard let user = Auth.auth().currentUser else {
            self.user = .emptyUser
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
            try await self.user.saveUserData()
        }
        self.state = .signedIn
    }
    
    @MainActor
    private func getCredential() async throws -> AuthCredential {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("fatal_error_sdk_is_not_integrated")
        }
        let configuration = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = configuration
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            fatalError("fatal_error_is_not_get_window_scene")
        }
        guard let rootViewController = windowScene.windows.first?.rootViewController else {
            fatalError("fatal_error_is_not_get_view_controller")
        }
        let signResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
        
        let accessToken = signResult.user.accessToken
        guard let idToken = signResult.user.idToken else {
            fatalError("fatal_error_is_not_get_id_token")
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
            fatalError("fatal_error_re_authenticate_user")
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
            fatalError("fatal_error_is_not_get_current_user")
        }
        try await user.delete()
        try await checkUser()
    }
    
}

