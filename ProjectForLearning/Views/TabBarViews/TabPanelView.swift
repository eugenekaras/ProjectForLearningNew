//
//  TabView.swift
//  ProjectForLearning
//
//  Created by Евгений Карась on 20.01.23.
//

import SwiftUI

struct TabPanelView: View {
    let tabItems: [TabViewModel]
    @State private var selectedTab = 1
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            ForEach(tabItems) { tabItem in
                TabItem(tabViewModel: tabItem)
            }
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabPanelView(tabItems: Array(tabViewModelArr.prefix(3)))
    }
}
