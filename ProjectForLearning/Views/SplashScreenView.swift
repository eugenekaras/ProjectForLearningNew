//
//  SplashScreenView.swift
//  ProjectForLearning
//
//  Created by Евгений Карась on 19.01.23.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        VStack{
            VStack{
                Image(systemName: "swift")
                    .font(.system(size: 80))
                    .foregroundColor(.purple)
                Text("greeting_splash_screen_view")
                    .font(.system(size: 23))
                    .foregroundColor(.black.opacity(0.80))
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
