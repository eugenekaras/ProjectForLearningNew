//
//  TopItemProfile.swift
//  ProjectForLearning
//
//  Created by Евгений Карась on 20.01.23.
//

import SwiftUI

struct ProfileView: View {
    enum TypeAlert {
        case errorOther
        case errorDeletingUser
    }
    @EnvironmentObject var userAuth: UserAuth
    
    @State private var isShowingActionSheet = false
    @State private var showAlert = false
    @State private var typeAlert: TypeAlert  = .errorOther
    @State private var messageError = ""
    @State private var titleError = ""
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    UserImage(url: userAuth.user?.url)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100, alignment: .center)
                        .cornerRadius(8)
                    VStack(alignment: .leading) {
                        Text(userAuth.user?.displayName ?? "Anonymous")
                            .font(.headline)
                        
                        Text(userAuth.user?.email ?? "")
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
                    Text("Sign out")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemIndigo))
                        .cornerRadius(13)
                        .padding()
                }
                .actionSheet(isPresented: $isShowingActionSheet) {
                    ActionSheet(title: Text("Confirm your actions"),
                                message: Text("Are you su re you want to log out of your profile?"),
                                buttons: [.default(Text("Delete account"),
                                                   action: {
                        deleteUser()
                    }),.destructive(Text("Sign out"),action: {
                        signOut()
                    })
                                          ,.cancel()])
                }
            }
            .alert(isPresented: $showAlert) {
                switch self.typeAlert {
                case .errorDeletingUser:
                    return  Alert(
                        title:  Text(titleError),
                        message: Text(messageError),
                        primaryButton: .default(
                            Text("Cancel"),
                            action: { }
                        ),
                        secondaryButton: .destructive(
                            Text("Delete"),
                            action: {
                                reSignAndDeleteUser()
                            }
                        )
                    )
                case .errorOther:
                    return  Alert(
                        title: Text(titleError),
                        dismissButton: .default(Text("Ok"))
                    )
                }
            }
        }
    }

    func deleteUser() {
        Task {
            do {
                try await userAuth.deleteUser()
            } catch {
                showAlert(error: error)
            }
        }
    }
    func reSignAndDeleteUser() {
        Task {
            do {
                try await userAuth.reauthenticate()
                try await userAuth.deleteUser()
            } catch {
                showAlert(error: error)
            }
        }
    }
    
    func signOut() {
        Task {
            do {
                try await userAuth.signOut()
            } catch {
                showAlert(error: error)
            }
        }
    }
    
    @MainActor
    func showAlert(error: Error) {
        if (error as NSError).code == 17014 {
            typeAlert = .errorDeletingUser
            self.messageError = "You need to login again"
            self.titleError = "Are you sure to delete the user?"
        } else {
            typeAlert = .errorOther
            self.messageError = ""
            self.titleError = error.localizedDescription
        }
        self.showAlert.toggle()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var userAuth = UserAuth()
    
    static var previews: some View {
        ProfileView()
            .environmentObject(userAuth)
    }
}
