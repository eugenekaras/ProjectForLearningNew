//
//  LoginHeader.swift
//  ProjectForLearning
//
//  Created by Евгений Карась on 20.01.23.
//

import SwiftUI

struct LoginHeader: View {
    var body: some View {
        VStack {            
            Text("Welcome")
                .font(.largeTitle)
                .fontWeight(.medium)
                .padding()
                .multilineTextAlignment(.center)
        }
    }
}

struct LoginHeader_Previews: PreviewProvider {
    static var previews: some View {
        LoginHeader()
    }
}
