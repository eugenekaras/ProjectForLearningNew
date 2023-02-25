//
//  TopItemProfile.swift
//  ProjectForLearning
//
//  Created by Евгений Карась on 20.01.23.
//

import SwiftUI
import FirebaseAuth
import Factory

enum ProfileViewError: LocalizedError {
    case unknownError(error: Error)
    
    var errorDescription: String? {
        switch self {
        case .unknownError(let error):
            return error.localizedDescription
        }
    }
}

struct ProfileView: View {
    @EnvironmentObject private var appState: AppState
    @Injected(Container.authenticationService) private var authenticationService
        
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var bio: String = ""
    @State private var userAvatar: UserAvatar = .unknown
    
    @State private var showSignOutActionSheet = false
    @State private var showDialogForUserDelete = false
    @State private var showingEditUserInfoView = false
    @State private var error: ProfileViewError?
    @State private var showError = false
            
    var body: some View {
        VStack {
            userInfoView
            
            Spacer()
            
            Text("greeting_profile_view")
            
            Spacer()
            
            signOutButtonView
        }
        .alert(isPresented: $showError, error: error, actions: {})
        .onReceive(appState.userState.$user) { user in
            self.name = user.firstName + " " + user.lastName
            self.email = user.email
            self.phoneNumber = user.phoneNumber
            self.bio = user.bio
            self.userAvatar = user.userAvatar
        }

    }
    
    private var userInfoView:  some View {
        ZStack(alignment: .topTrailing) {
            HStack{
                UserInfoImageView(userAvatar: userAvatar)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100, alignment: .center)
                    .cornerRadius(8)
                VStack(alignment: .leading, spacing: 1) {
                    Text(name)
                        .font(.headline)
                    
                    Text(email)
                        .font(.subheadline)
                    
                    Text(phoneNumber)
                        .font(.subheadline)
                    
                    Text(bio)
                        .font(.footnote)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            
            buttonShowEditUserInfoView
        }
        .padding()
        .sheet(isPresented: $showingEditUserInfoView) {
            EditUserInfoView()
        }
    }
    
    private var buttonShowEditUserInfoView: some View {
        Button  {
            self.showingEditUserInfoView.toggle()
        } label: {
            Image(systemName: "pencil")
                .font(.largeTitle)
                .padding(7)
                .background(Color(.systemIndigo))
                .foregroundColor(.white)
                .clipShape(Capsule())
                .padding()
        }
    }
    
    private var signOutButtonView: some View {
        Group{
            Button  {
                self.showSignOutActionSheet = true
            } label: {
                Text("sign_out")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemIndigo))
                    .cornerRadius(13)
                    .padding()
            }
        }
        .actionSheet(isPresented: $showSignOutActionSheet) {
            signOutActionSheet
        }
        .confirmationDialog("question_profile_view_delete_account", isPresented: $showDialogForUserDelete, actions: {
            Button("delete", role: .destructive) {
                reauthenticateAndDeleteUser()
            }
            Button("cancel", role: .cancel) {
                showDialogForUserDelete = false
            }
        })
    }
    
    var signOutActionSheet: ActionSheet {
        ActionSheet(
            title: Text("confirm_actions"),
            message: Text("question_profile_view_logout_profile"),
            buttons: [
                .default(Text("delete_account")) {
                    deleteUser()
                },
                .destructive(Text("sign_out")) {
                    signOut()
                },
                .cancel()
            ])
    }
    
    func deleteUser() {
        Task {
            do {
                try await authenticationService.deleteUser()
                
                appState.userState.state = .signedOut
                appState.userState.user = .emptyUser
            } catch {
                showError(error: error)
            }
        }
    }
    
    func reauthenticateAndDeleteUser() {
        Task {
            do {
                try await authenticationService.reauthenticate()
                try await authenticationService.deleteUser()
                
                appState.userState.state = .signedOut
                appState.userState.user = .emptyUser
            } catch {
                showError(error: error)
            }
        }
    }
    
    func signOut() {
        Task {
            do {
                try await authenticationService.signOut()
                
                appState.userState.state = .signedOut
                appState.userState.user = .emptyUser
            } catch {
                showError(error: error)
            }
        }
    }
    
    @MainActor
    func showError(error: Error) {
        guard let error = error as NSError? else {
            fatalError("unknown_error")
        }
        let code = AuthErrorCode(_nsError: error).code
        if code == .requiresRecentLogin {
            self.showDialogForUserDelete.toggle()
        } else {
            self.error = ProfileViewError.unknownError(error: error)
            self.showError.toggle()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var appState = AppState()
    
    static var previews: some View {
        ProfileView()
            .environmentObject(appState)
    }
}
