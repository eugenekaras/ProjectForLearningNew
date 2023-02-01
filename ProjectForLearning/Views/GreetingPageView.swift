//
//  GeetingPageView.swift
//  ProjectForLearning
//
//  Created by Евгений Карась on 22.01.23.
//

import SwiftUI

struct GreetingPageView: View {
    
    @EnvironmentObject var viewState: ViewState
    
    var body: some View {
        
        VStack{
            VStack{
                Text("Welcome")
                    .font(.system(size: 38))
                    .foregroundColor(.black.opacity(0.80))
            }
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
                withAnimation{
                    viewState.contentViewState = .signIn
                }

            }
        }
    }
}

struct GettingPageView_Previews: PreviewProvider {
    static var previews: some View {
        GreetingPageView()
    }
}
