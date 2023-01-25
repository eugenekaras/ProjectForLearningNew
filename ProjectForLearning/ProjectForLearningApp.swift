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
struct ProjectForLearningApp: App
{
    
    @StateObject var authenticationModel = AuthenticationModel()
    @StateObject var viewModel = ViewModel()
    
    init() {
        setupAuthentication()
    }
    
    var body: some Scene {
        WindowGroup {
            
            ContentView()
                .environmentObject(authenticationModel)
                .environmentObject(viewModel)
            
        }
    }
}
