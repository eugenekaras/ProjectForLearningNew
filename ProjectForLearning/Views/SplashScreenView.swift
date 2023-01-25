//
//  SplashScreenView.swift
//  ProjectForLearning
//
//  Created by Евгений Карась on 19.01.23.
//

import SwiftUI

struct SplashScreenView: View {
    
    
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    @EnvironmentObject var authenticationModel: AuthenticationModel
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        
        VStack{
            VStack{
                Image(systemName: "swift")
                    .font(.system(size: 80))
                    .foregroundColor(.purple)
                Text("Study App")
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
            Task {
                do{
                    try await authenticationModel.signInIfSigned()
                    if authenticationModel.state == .signedIn {
                        viewModel.isShowSplashScreenView = false
                    }
                } catch{
                    
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
                withAnimation{
                    
                    viewModel.isShowSplashScreenView = false
                }
                
            }
        }
        
    }
    
    
}


struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
