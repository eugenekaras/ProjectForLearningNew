//
//  ContentView.swift
//  ProjectForLearning
//
//  Created by Евгений Карась on 18.01.23.
//

import SwiftUI



struct ContentView: View {
    
    @EnvironmentObject var userAuth: UserAuth
    @EnvironmentObject var viewState: ViewState

    var body: some View {
        
        Group {
            switch viewState.contentViewState {
            case .signOut: SignInView()
            case .splash: SplashScreenView()
            case .signIn: TabBarView()
            case .greeting: GreetingPageView()
            }

        }
        .task {
            userAuth.checkSignIn()
        }
        .onChange(of: userAuth.state) { [state = userAuth.state] newValue in
            if (state == .signedOut) && (newValue == .signedIn) {
                viewState.contentViewState = .greeting
            } else {
                switch newValue {
                case .signedOut: viewState.contentViewState = .signOut
                case .unknown: viewState.contentViewState = .splash
                case .signedIn: viewState.contentViewState = .signIn
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView( )
    }
}
