//
//  AuthenticationService.swift
//  ProjectForLearning
//
//  Created by Sergei Bogachev on 22/02/2023.
//

import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

final class AuthenticationService {
    
    struct UserInfo {
        let userID: String
        let email: String?
        let displayName: String?
        let phoneNumber: String?
        let photoURL: URL?
    }
    
    enum UserState {
        case signedIn(UserInfo)
        case signedOut
    }
    
    init() {
        
    }
                
    func userState() async throws -> UserState {
        guard let user = Auth.auth().currentUser else {
            return .signedOut
        }
        
        try await user.reload()
        
        let userInfo = UserInfo(
            userID: user.uid,
            email: user.email,
            displayName: user.displayName,
            phoneNumber: user.phoneNumber,
            photoURL: user.photoURL
        )
        
        return .signedIn(userInfo)
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
    
    func signInAnonymously() async throws -> UserInfo {
        let result = try await Auth.auth().signInAnonymously()
        
        let user = result.user
        
        let userInfo = UserInfo(
            userID: user.uid,
            email: user.email,
            displayName: user.displayName,
            phoneNumber: user.phoneNumber,
            photoURL: user.photoURL
        )

        return userInfo
    }
    
    func signIn() async throws -> UserInfo {
        let credential = try await getCredential()
        let result = try await Auth.auth().signIn(with: credential)

        let user = result.user
        
        let userInfo = UserInfo(
            userID: user.uid,
            email: user.email,
            displayName: user.displayName,
            phoneNumber: user.phoneNumber,
            photoURL: user.photoURL
        )

        return userInfo
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
    }
    
    func deleteUser() async throws {
        guard let user = Auth.auth().currentUser else {
            fatalError("fatal_error_is_not_get_current_user")
        }
        try await user.delete()
    }
    
}
