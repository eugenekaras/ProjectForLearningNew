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
                    Label(tabViewModels[0].tabItem.rawValue, systemImage: tabViewModels[0].image)
                }.tag(tabViewModels[0].id)
            
            MainView()
                .tabItem {
                    Label(tabViewModels[1].tabItem.rawValue, systemImage: tabViewModels[1].image)
                }.tag(tabViewModels[1].id)
            ProfileView()
                .tabItem {
                    Label(tabViewModels[2].tabItem.rawValue, systemImage: tabViewModels[2].image)
                }.tag(tabViewModels[2].id)
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
