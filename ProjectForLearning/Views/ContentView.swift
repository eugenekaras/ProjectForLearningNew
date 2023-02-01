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
            switch userAuth.state {
            case .signedOut: SignInView()
            case .unknown: SplashScreenView()
            case .signedIn:TabBarView()
            }
        }
        .task {
            userAuth.checkSignIn()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView( )
    }
}
