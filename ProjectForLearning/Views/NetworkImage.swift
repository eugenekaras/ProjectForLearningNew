//
//  NetworkImage.swift
//  ProjectForLearning
//
//  Created by Евгений Карась on 3.02.23.
//

import SwiftUI

struct NetworkImage: View {
    let url: URL?
    
    var body: some View {
        if let url = url {
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
        } else {
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}

struct NetworkImage_Previews: PreviewProvider {
    static var previews: some View {
        NetworkImage(url: nil)
    }
}
