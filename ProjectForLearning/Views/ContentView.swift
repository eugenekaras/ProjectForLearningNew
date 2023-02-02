//
//  ContentView.swift
//  ProjectForLearning
//
//  Created by Евгений Карась on 18.01.23.
//

import SwiftUI

enum ContentViewState {
    case splash
    case greeting
    case signIn
    case signOut
}

struct ContentView: View {
    
    @EnvironmentObject var userAuth: UserAuth
    
    @State private var contentViewState = ContentViewState.splash
    
    func updateViewState(with signInState: UserAuth.SignInState) {
        var contentViewState = contentViewState
        
        if (contentViewState == .signOut) && (signInState == .signedIn) {
            self.contentViewState = .greeting
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
                self.contentViewState = .signIn
            }
        } else {
            switch signInState {
            case .signedOut: self.contentViewState = .signOut
            case .unknown: self.contentViewState = .splash
            case .signedIn: self.contentViewState = .signIn
            }
        }
    }
    
    var body: some View {
        
        Group {
            switch self.contentViewState {
            case .signOut: SignInView()
            case .splash: SplashScreenView()
            case .signIn: TabBarView()
            case .greeting: GreetingPageView()
            }
        }
        .animation(.default, value: self.contentViewState)
        .task {
            userAuth.checkSignIn()
        }
        .onChange(of: userAuth.state) { newValue in
            updateViewState(with: newValue)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView( )
    }
}
