//
//  GeetingPageView.swift
//  ProjectForLearning
//
//  Created by Евгений Карась on 22.01.23.
//

import SwiftUI

struct GeetingPageView: View {
    
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        if isActive {

            switch viewModel.state  {
            case .signedIn: ContentView()
            case .signedOut: SignInWithGoogle()
            }
            
        } else {
         
            VStack{
                VStack{
                    Image(systemName: "function")
                        .font(.system(size: 80))
                        .foregroundColor(.purple)
                        .padding(20)
                    Text("Welcome")
                        .font(.system(size: 23))
                        .foregroundColor(.black.opacity(0.80))
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear{
                    withAnimation(.easeIn(duration: 1.2)){
                        self.size = 0.9
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
                    withAnimation{
                        self.isActive = true
                    }
                    
                }
            }
        
        }
        
    }
}

struct GeetingPageView_Previews: PreviewProvider {
    static var previews: some View {
        GeetingPageView()
    }
}
