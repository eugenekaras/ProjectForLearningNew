//
//  NetworkImage.swift
//  ProjectForLearning
//
//  Created by Евгений Карась on 3.02.23.
//

import SwiftUI

struct UserInfoImageView: View {
    var userAvatar: UserAvatar
    
    var body: some View {
        switch userAvatar {
        case .image(let image):
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
        case .url(let url):
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
        case .unknown:
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}

struct NetworkImage_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoImageView(userAvatar: .unknown)
    }
}
