//
//  ContentView.swift
//  ProjectForLearning
//
//  Created by Евгений Карась on 18.01.23.
//

import SwiftUI
import Factory

enum ContentViewError: LocalizedError {
    case unknownError(error: Error)
    
    var errorDescription: String? {
        switch self {
        case .unknownError(let error):
            return error.localizedDescription
        }
    }
}

enum ContentViewState {
    case splash
    case greeting
    case signIn
    case signOut
}

struct ContentView: View {
    @EnvironmentObject private var appState: AppState
    
    @Injected(Container.authenticationService) private var authenticationService
    
    @State private var contentViewState = ContentViewState.splash
    @State private var showError = false
    @State private var error: ContentViewError?
    
    var body: some View {
        let _ = Self._printChanges()

        Group {
            switch self.contentViewState {
            case .splash: SplashScreenView()
            case .greeting: GreetingPageView()
            case .signIn: MainTabBarView()
            case .signOut: SignInView()
            }
        }
        .animation(.default, value: self.contentViewState)
        .task {
            getReady()
        }
        .onReceive(appState.userAuth.$userState) { state in
            updateViewState(with: state)
        }
    }
    
    func updateViewState(with signInState: UserAuth.UserState) {
        if (self.contentViewState == .signOut) && (signInState == .signedIn) {
            self.contentViewState = .greeting
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
                self.contentViewState = .signIn
            }
        } else {
            switch signInState {
            case .unknown: self.contentViewState = .splash
            case .signedIn: self.contentViewState = .signIn
            case .signedOut: self.contentViewState = .signOut
            }
        }
    }
    
    func getReady() {
          Task {
              do {
                  let userState = try await authenticationService.userState()
                  switch userState {
                  case .signedIn(let userInfo):
                      let user = try User.restoreUser(userId: userInfo.userID) ?? User(userId: userInfo.userID, email: userInfo.email, displayName: userInfo.displayName, phoneNumber: userInfo.phoneNumber, url: userInfo.photoURL)
                      
                      appState.userAuth.user = user
                      
                      appState.userAuth.userState = .signedIn
                  case .signedOut:
                      appState.userAuth.userState = .signedOut
                  }
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
        self.error = ContentViewError.unknownError(error: error)
        self.showError.toggle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var userAuth = UserAuth()
    
    static var previews: some View {
        ContentView()
            .environmentObject(userAuth)
    }
}
