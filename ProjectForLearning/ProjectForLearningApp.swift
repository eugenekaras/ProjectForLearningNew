//
//  ProjectForLearningApp.swift
//  ProjectForLearning
//
//  Created by Евгений Карась on 18.01.23.
//

import SwiftUI
import Firebase

extension ProjectForLearningApp {
    private func setupAuthentication() {
        FirebaseApp.configure()
    }
}
//final class AppDelegate: NSObject, UIApplicationDelegate {
//  func application(_ application: UIApplication,
//                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//    FirebaseApp.configure()
//    return true
//  }
//
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        return GIDSignIn.sharedInstance.handle(url)
//    }
//}

@main
struct ProjectForLearningApp: App {
    
    @StateObject var viewModel = AuthenticationViewModel()
    
    init() {
        setupAuthentication()
    }
    
    //    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(viewModel)
        }
    }
}
