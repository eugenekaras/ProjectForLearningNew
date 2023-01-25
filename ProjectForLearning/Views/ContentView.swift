//
//  ContentView.swift
//  ProjectForLearning
//
//  Created by Евгений Карась on 18.01.23.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authenticationModel: AuthenticationModel
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        
        if !viewModel.isShowSplashScreenView {
            switch authenticationModel.state {
            case .signedIn:
                switch viewModel.isShowGettingPage {
                case true: GettingPageView()
                case false: TabBarView()
                }
            case .signedOut: SignInView()
            }
        } else {
            SplashScreenView()
        }
        
    }
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
