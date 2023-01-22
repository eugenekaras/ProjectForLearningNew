//
//  LoginScreen.swift
//  ProjectForLearning
//
//  Created by Евгений Карась on 20.01.23.
//

import SwiftUI
import GoogleSignInSwift
import GoogleSignIn
import Firebase
import FirebaseCore
import FirebaseAuth

struct LoginScreen: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        NavigationView{
            VStack(alignment: .center, spacing: 0) {
                
                LoginHeader()
                    .padding(100)
                Spacer()
                
                GoogleSignInButton{
                    viewModel.isShowGeetingPage = true
                    viewModel.signIn()
                }.padding(20)
 
                Spacer()
            }
        }
    }
}


struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
