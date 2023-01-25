//
//  SignInWithGoogle.swift
//  ProjectForLearning
//
//  Created by Евгений Карась on 20.01.23.
//

import SwiftUI
import GoogleSignInSwift


struct SignInView: View {
    
    @EnvironmentObject var authenticationModel: AuthenticationModel
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView{
            VStack(alignment: .center, spacing: 0) {
                
                LoginHeader()
                    .padding(100)
                Spacer()
                
                GoogleSignInButton{
                    Task {
                        do{
                            try await authenticationModel.signIn()
                            if authenticationModel.state == .signedIn {
                                viewModel.isShowGettingPage = true
                            }
                        } catch{
                            
                        }
                    }
                }.padding(20)
                
                Button(action: {
                    Task {
                        do{
                            try await authenticationModel.signInAnonymously()
                            if authenticationModel.state == .signedIn {
                                viewModel.isShowGettingPage = true
                            }
                        } catch{
                            
                        }
                    }
                }) {
                    HStack {
                        Spacer()
                        Text("Use anonymous account")
                            .foregroundColor(.white)
                        Spacer()
                    }
                }
                .padding()
                .background(.black)
                .padding()
                
                Spacer()
            }
        }
    }
}

struct LoginHeader: View {
    var body: some View {
        VStack {
            Image(systemName: "bonjour")
                .font(.system(size: 120))
                .foregroundColor(.purple)
            Text("Study App")
                .font(.system(size: 36))
                .foregroundColor(.black.opacity(0.80))
        }
    }
}


struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

