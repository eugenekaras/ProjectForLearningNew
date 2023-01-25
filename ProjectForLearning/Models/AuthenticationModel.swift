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

extension AuthenticationModel{
    var Context: UIViewController{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        return root
    }
}


class AuthenticationModel: ObservableObject {
    
    enum SignInState {
        case signedIn
        case signedOut
    }
    
    
    @Published var state: SignInState =  .signedOut
    
    func signInIfSigned() async throws -> Bool {
        return checkSignIn()
    }
    
    func checkSignIn() -> Bool {
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
                authenticateUser(for: user, with: error)
            }
        }
        if self.state == .signedIn {
            return true
        }
        return false
    }
    
    func signIn() async throws {
        
        if !checkSignIn() {
            
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            
            
            let configuration = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = configuration
            
            GIDSignIn.sharedInstance.signIn(withPresenting: Context) { [unowned self ] signResult, error in
                self.authenticateUser(for: signResult?.user, with: error)
            }
        }
        
        
    }
    
    func signInAnonymously() async throws {
        
        
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
                authenticateUser(for: user, with: error)
            }
        } else {
            
            Auth.auth().signInAnonymously { authResult, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    self.state = .signedIn
                }
                
            }
        }
        
    }
    
    private func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let accessToken = user?.accessToken else { return }
        guard let idToken = user?.idToken else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
        
        Auth.auth().signIn(with: credential) {  [unowned self] authResult, error in
            
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.state = .signedIn
            }
            
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            state = .signedOut
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteUser() {
        
        let user = Auth.auth().currentUser
        
        user?.delete { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.signOut()
                print("Account deleted")
            }
            
            
        }
        
    }
    
}
