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
        guard let user = Auth.auth().currentUser else {
            self.session = nil
            self.state = .signedOut
            return
        }
        self.session =  User( userId: user.uid, email: user.email, displayName: user.displayName, url: user.photoURL)
        self.state = .signedIn
    }
    
    private func getCredential() async throws -> AuthCredential {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("Firebase SDK is not integrated properly")
        }
        let configuration = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = configuration
        
        guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            fatalError("Error getting UIWindowScene")
        }
        guard let rootViewController = await windowScene.windows.first?.rootViewController else {
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
        let authResult = try await Auth.auth().signInAnonymously()

        DispatchQueue.main.asyncAfter(deadline: .now()){
            self.session = User(
                userId: authResult.user.uid,
                email: authResult.user.email,
                displayName: authResult.user.displayName,
                url: authResult.user.photoURL
            )
            self.state = .signedIn
        }
    }
    
    func signIn() async throws {
        let credential = try await getCredential()
        let authResult =  try await Auth.auth().signIn(with: credential)
        
        DispatchQueue.main.asyncAfter(deadline: .now()){
            self.session =  User(
                userId: authResult.user.uid,
                email: authResult.user.email,
                displayName: authResult.user.displayName,
                url: authResult.user.photoURL
            )
            self.state = .signedIn
        }
    }
    
    func reSignIn() async throws {
        if let user = Auth.auth().currentUser {
            let credential = try await getCredential()
            let authResult =  try await user.reauthenticate(with: credential)
            
            DispatchQueue.main.asyncAfter(deadline: .now()){
                self.session =  User(
                    userId: authResult.user.uid,
                    email: authResult.user.email,
                    displayName: authResult.user.displayName,
                    url: authResult.user.photoURL
                )
                self.state = .signedIn
            }
        } else {
            fatalError("Error re-authenticate a user")
        }
    }
    
    func signOut() async throws {
        let firebaseAuth = Auth.auth()
        try firebaseAuth.signOut()
        DispatchQueue.main.asyncAfter(deadline: .now()){
            self.session = nil
            self.state = .signedOut
        }
    }
    
    func deleteUser() async throws {
        guard let user = Auth.auth().currentUser else {
            fatalError("Error getting current user for delete")
        }
        try await user.delete()
        DispatchQueue.main.asyncAfter(deadline: .now()){
            self.session = nil
            self.state = .signedOut
        }
    }
}

