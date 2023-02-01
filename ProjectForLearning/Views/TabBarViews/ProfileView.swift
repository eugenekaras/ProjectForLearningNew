//
//  TopItemProfile.swift
//  ProjectForLearning
//
//  Created by Евгений Карась on 20.01.23.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var userAuth: UserAuth
    
    @State private var isShowingActionSheet = false
    @State private var messageError = ""
    @State private var showError = false
    
    func deleteUser() {
        Task {
            do {
                try await userAuth.deleteUser()
            } catch {
                showError(error: error)
            }
        }
    }
    
    func signOut() {
        Task {
            do {
                try await userAuth.signOut()
            } catch {
                showError(error: error)
            }
        }
    }
    
    @MainActor
    func showError(error: Error) {
        self.messageError = error.localizedDescription
        self.showError.toggle()
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    NetworkImage(url: userAuth.session?.url)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100, alignment: .center)
                        .cornerRadius(8)
                    VStack(alignment: .leading) {
                        Text(userAuth.session?.displayName ?? "Anonymous")
                            .font(.headline)
                        
                        Text(userAuth.session?.email ?? "")
                            .font(.subheadline)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .padding()
                
                Spacer()
                
                Text("Hello, from Profile!")
                
                Spacer()
                
                Button  {
                    self.isShowingActionSheet = true
                } label: {
                    Text("Sign Out")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemIndigo))
                        .cornerRadius(13)
                        .padding()
                }
                .actionSheet(isPresented: $isShowingActionSheet) {
                    ActionSheet(title: Text("Confirm your actions"),
                                message: Text("Are you sure you want to log out of your profile?"),
                                buttons: [.default(Text("Delete account"),
                                                   action: {
                        deleteUser()
                    }),.destructive(Text("Sign out"),action: {
                        signOut()
                    })
                                          ,.cancel()])
                }
                .alert(
                    messageError,
                    isPresented: $showError
                ) {
                    Button("OK") {
                        
                    }
                }
            }
        }
    }
}

struct NetworkImage: View {
    let url: URL?
    
    var body: some View {
        if let url = url,
           let data = try? Data(contentsOf: url),
           let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
