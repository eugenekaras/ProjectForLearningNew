//
//  TabView.swift
//  ProjectForLearning
//
//  Created by Евгений Карась on 20.01.23.
//

import SwiftUI

struct TabBarView: View {
    
    @State private var selectedTab = 2
    
    var body: some View {
        
        TabView {
            SomeView()
                .tabItem {
                    Label("Some View", systemImage: "square.dashed")
                }.tag(0)
            
            MainView()
                .tabItem {
                    Label("Main", systemImage: "app")
                }.tag(1)
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }.tag(2)
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}