//
//  NetworkImage.swift
//  ProjectForLearning
//
//  Created by Евгений Карась on 3.02.23.
//

import SwiftUI

struct UserInfoImageView: View {
    var user: User?
    
    var body: some View {
        if let image = user?.image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else if let url = user?.url {
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
        UserInfoImageView(user: User.userDefault)
    }
}
