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
import FirebaseCore
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
 
    func signIn(handler: @escaping (Bool,String) -> Void) async throws {
        
        if session != nil {
            self.state = .signedIn
            handler(true,"isSigned")
        } else {
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            
            let configuration = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = configuration
            
            guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let rootViewController = await windowScene.windows.first?.rootViewController else { return
                
            }
            
//            Task{
//                {
                    GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [unowned self ] signResult, error in
                        authenticateUser(for: signResult?.user, with: error, handler: handler)
                    }
//                }()
            }
    }
    
    
    
    func signInAnonymously(handler: @escaping (Bool,String) -> Void) async throws {
        
        if session != nil {
            self.state = .signedIn
            handler(true,"isSigned")
        } else {
            
            Auth.auth().signInAnonymously { authResult, error in
                if let error = error {
                    print(error.localizedDescription)
                    handler(false,error.localizedDescription)
                } else {
                    self.session =  User( userId: authResult?.user.uid ?? "", email: authResult?.user.email, displayName: authResult?.user.displayName, url: authResult?.user.photoURL)
                    self.state = .signedIn
                    handler(true,"isSigned")
                }
            }
            
        }
    }

    
    private func authenticateUser(for user: GIDGoogleUser?, with error: Error?, handler:  @escaping (Bool,String) -> Void) {
        
        if let error = error {
            
            handler(false,error.localizedDescription)
            return
            
        }
        
        guard let accessToken = user?.accessToken else { return }
        guard let idToken = user?.idToken else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
        
        Auth.auth().signIn(with: credential) {  [unowned self] authResult, error in
            
            if let error = error {
    
                handler(false,error.localizedDescription)
                
            } else {
                self.session =  User( userId: authResult?.user.uid ?? "", email: authResult?.user.email, displayName: authResult?.user.displayName, url: authResult?.user.photoURL)
                self.state = .signedIn
                handler(true,"isSigned")
                
            }
            
        }
    }
    
    func signOut(output: (Bool,String) -> Void) {
        
//        GIDSignIn.sharedInstance.signOut()
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            state = .signedOut
            self.session = nil
            
        } catch {
            print(error.localizedDescription)
            output(false,error.localizedDescription)
        }
    }
    
    func deleteUser(output: @escaping (Bool,String) -> Void) {
        
        let user = Auth.auth().currentUser
        
        user?.delete { error in
            if let error = error {
                print(error.localizedDescription)
                output(false,error.localizedDescription)
            } else {
                self.signOut(output: output)

                print("Account deleted")
                
            }
        }
        
    }
}

