//
//  ContentView.swift
//  ProjectForLearning
//
//  Created by Евгений Карась on 18.01.23.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        
        switch viewModel.state {
        case .signedIn:
            switch viewModel.isShowGeetingPage {
            case true: GeetingPageView()
            case false: TabPanelView(tabItems: tabViewModelArr)
            }
        case .signedOut: SignInWithGoogle()
        }

    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
