//
//  GeetingPageView.swift
//  ProjectForLearning
//
//  Created by Евгений Карась on 22.01.23.
//

import SwiftUI

struct GreetingPageView: View {
    var body: some View {
        VStack{
            VStack{
                Text("Welcome")
                    .font(.system(size: 38))
                    .foregroundColor(.black.opacity(0.80))
            }
        }
    }
}

struct GettingPageView_Previews: PreviewProvider {
    static var previews: some View {
        GreetingPageView()
    }
}
