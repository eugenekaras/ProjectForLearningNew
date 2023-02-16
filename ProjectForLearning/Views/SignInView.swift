//
//  SignInWithGoogle.swift
//  ProjectForLearning
//
//  Created by Евгений Карась on 20.01.23.
//

import SwiftUI
import GoogleSignInSwift

struct SignInView: View {
    @EnvironmentObject var userAuth: UserAuth
    
    @State private var messageError = ""
    @State private var showError = false
    
    var body: some View {
        VStack {
            Spacer()
            
            headerView
            
            Spacer()
            
            googleSignInButtonView
            
            signInAnonymouslyButtonView
            
            Spacer()
        }
        .alert(
            messageError,
            isPresented: $showError
        ) {
            Button("Ok") { }
        }
    }
    
    private var headerView:  some View {
        VStack {
            Image(systemName: "bonjour")
                .font(.system(size: 120))
                .foregroundColor(.purple)
                .padding()
            Text("Study App")
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
                Text("Use anonymous account")
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
                try await userAuth.signIn()
                userAuth.state = .signedIn
            } catch {
                showError(error: error)
            }
        }
    }
    
    func signInAnonymously() {
        Task {
            do {
                try await userAuth.signInAnonymously()
            } catch {
                showError(error: error)
            }
        }
    }
    
    @MainActor
    func showError(error: Error) {
        self.messageError = error.localizedDescription
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
