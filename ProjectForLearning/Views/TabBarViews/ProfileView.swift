//
//  TopItemProfile.swift
//  ProjectForLearning
//
//  Created by Евгений Карась on 20.01.23.
//

import SwiftUI
import GoogleSignIn



struct ProfileView: View {
    
    @EnvironmentObject var userAuth: UserAuth
    @State private var isShowingActionSheet = false
    @State var message = ""
    @State var alert = false
    
    private let user = GIDSignIn.sharedInstance.currentUser
    
    var body: some View {
        
        ZStack {
            VStack {
                
                HStack {
                    
//                    NetworkImage(url: user?.profile?.imageURL(withDimension: 200))
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 100, height: 100, alignment: .center)
//                        .cornerRadius(8)
                    
//                    VStack(alignment: .leading) {
//                        Text(user?.profile?.name ?? "")
//                            .font(.headline)
//
//                        Text(user?.profile?.email ?? "")
//                            .font(.subheadline)
//                    }
                    
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
                .padding()
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
                    ActionSheet(title: Text("Confirm your actions"),message: Text("Are you sure you want to log out of your profile?"),
                                buttons: [.default(Text("Delete account"),action: {
                        userAuth.deleteUser(output: { verified, status in
                            if !verified {
                                self.message = status
                                self.alert.toggle()
                            }
                        })
                    }),.destructive(Text("Sign out"),action: {
                        userAuth.signOut(output: { verified, status in
                            if !verified {
                                self.message = status
                                self.alert.toggle()
                            }
                        })
                    })
                                          ,.cancel()])
                }
                .alert(isPresented: $alert) {
                    Alert(title: Text("Error"), message: Text(self.message), dismissButton: .default(Text("Ok")))
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
