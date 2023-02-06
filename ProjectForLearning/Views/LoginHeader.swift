//
//  LoginHeader.swift
//  ProjectForLearning
//
//  Created by Евгений Карась on 3.02.23.
//

import SwiftUI

struct LoginHeader: View {
    var body: some View {
        VStack {
            Image(systemName: "bonjour")
                .font(.system(size: 120))
                .foregroundColor(.purple)
            Text("Study App")
                .font(.system(size: 36))
                .foregroundColor(.black.opacity(0.80))
        }
    }
}

struct LoginHeader_Previews: PreviewProvider {
    static var previews: some View {
        LoginHeader()
    }
}
