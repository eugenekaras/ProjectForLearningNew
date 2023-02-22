//
//  SignInWithGoogle.swift
//  ProjectForLearning
//
//  Created by Евгений Карась on 20.01.23.
//

import SwiftUI
import GoogleSignInSwift

enum SignInError: LocalizedError {
    case unknownError(error: Error)
    
    var errorDescription: String? {
        switch self {
        case .unknownError(let error):
            return error.localizedDescription
        }
    }
}

struct SignInView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var showError = false
    @State private var error: SignInError?
    
    var body: some View {
        VStack {
            Spacer()
            
            headerView
            
            Spacer()
            
            googleSignInButtonView
            
            signInAnonymouslyButtonView
            
            Spacer()
        }
        .alert(isPresented: $showError, error: error) { Button("ok") { } }
    }
    
    private var headerView:  some View {
        VStack {
            Image(systemName: "bonjour")
                .font(.system(size: 120))
                .foregroundColor(.purple)
                .padding()
            Text("greeting_sign_in_view")
                .font(.system(size: 18))
                .foregroundColor(.black.opacity(0.80))
        }
    }
    
    private var googleSignInButtonView:  some View {
        GoogleSignInButton{
            signIn()
        }
        .padding()
    }
    
    private var signInAnonymouslyButtonView:  some View {
        Button {
            signInAnonymously()
        } label: {
            HStack {
                Spacer()
                Text("sign_in_anonymously_button")
                    .foregroundColor(.white)
                Spacer()
            }
        }
        .frame(height: 40)
        .background(.black)
        .padding()
    }

    func signIn() {
        Task {
            do {
                try await appState.userAuth.signIn()
                appState.userAuth.state = .signedIn
            } catch {
                showError(error: error)
            }
        }
    }
    
    func signInAnonymously() {
        Task {
            do {
                try await appState.userAuth.signInAnonymously()
            } catch {
                showError(error: error)
            }
        }
    }
    
    @MainActor
    func showError(error: Error) {
        guard let error = error as NSError? else {
            fatalError("unknown_error")
        }
        self.error = SignInError.unknownError(error: error)
        self.showError.toggle()
    }
}

struct SignInView_Previews: PreviewProvider {
    static var userAuth = UserAuth()
    
    static var previews: some View {
        SignInView()
            .environmentObject(userAuth)
    }
}
