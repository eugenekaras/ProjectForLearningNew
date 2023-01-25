//
//  GeetingPageView.swift
//  ProjectForLearning
//
//  Created by Евгений Карась on 22.01.23.
//

import SwiftUI

struct GettingPageView: View {
    
    @EnvironmentObject var authenticationModel: AuthenticationModel
    @EnvironmentObject var viewModel: ViewModel
    
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
                    viewModel.isShowGettingPage = false
                }

            }
        }
        
        
    }
}

//struct GeetingPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        GettingPageView()
//    }
//}
