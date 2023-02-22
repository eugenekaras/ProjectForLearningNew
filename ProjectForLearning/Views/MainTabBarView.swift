//
//  TabView.swift
//  ProjectForLearning
//
//  Created by Евгений Карась on 20.01.23.
//

import SwiftUI

struct MainTabBarView: View {
    @EnvironmentObject private var appState: AppState

    @State private var selectedTab = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            SomeView()
                .tabItem {
                    Label("some_view", systemImage: "square.dashed")
                }.tag(0)
            MainView()
                .tabItem {
                    Label("main_view", systemImage: "app")
                }.tag(1)
            ProfileView(user: $appState.userState.user)
                .tabItem {
                    Label("profile_view", systemImage: "person.fill")
                }.tag(2)
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var userState = UserState()
    
    static var previews: some View {
        MainTabBarView()
            .environmentObject(userState)
    }
}
