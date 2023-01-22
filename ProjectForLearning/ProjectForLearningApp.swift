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

@main
struct ProjectForLearningApp: App {
    
    @StateObject var viewModel = AuthenticationViewModel()
    
    init() {
        setupAuthentication()
    }

    var body: some Scene {
        WindowGroup {
 
            SplashScreenView()
                .environmentObject(viewModel)
            
        }
    }
}
