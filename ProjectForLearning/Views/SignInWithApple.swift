//
//  SignInWithApple.swift
//  ProjectForLearning
//
//  Created by Евгений Карась on 19.01.23.
//
import AuthenticationServices
import SwiftUI

struct SignInWithApple: View {

    @AppStorage("userId") var userId: String = ""
    
    private var isSignedIn: Bool {
        !userId.isEmpty
    }
    var body: some View {
        NavigationView{
            VStack{
                
                if !isSignedIn {
                    SignInButtonView()
                } else {
                    Text("Welcome back!")
                }
                

            }
            .navigationTitle("Sign In")
        }
    }
}

struct SignInButtonView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("userId") var userId: String = ""
    
    var body: some View {
        SignInWithAppleButton(.continue) { request in
            request.requestedScopes = [.email, .fullName]
        } onCompletion: { result in
            switch result {
            case .success(let auth):
                
                switch auth.credential {
                case let credential as ASAuthorizationAppleIDCredential:
                    
                    let userId = credential.user
                    self.userId = userId

                default:
                    break
                }
            default:
                break
            }
        }
        .signInWithAppleButtonStyle(
            colorScheme == .dark ? .white : .black
        )
        .frame(height: 50)
        .padding()
        .cornerRadius(8)
    }
}

struct SignInWithApple_Previews: PreviewProvider {
    static var previews: some View {
        SignInWithApple()
    }
}
