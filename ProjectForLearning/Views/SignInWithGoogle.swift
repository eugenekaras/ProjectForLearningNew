//
//  SignInWithGoogle.swift
//  ProjectForLearning
//
//  Created by Евгений Карась on 20.01.23.
//

import SwiftUI
 
struct SignInWithGoogle: View {
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View {
    
        switch viewModel.state {
        case .signedIn: ContentView()
        case .signedOut: LoginScreen()
        }
        
    }
}
