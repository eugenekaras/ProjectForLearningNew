//
//  TabItem.swift
//  ProjectForLearning
//
//  Created by Евгений Карась on 20.01.23.
//

import SwiftUI

struct TabItem: View {
    var tabViewModel: TabViewModel
    var body: some View {
        VStack{
            switch tabViewModel.tabItem {
            case .someView: TopItemSomeView()
            case .main: TopItemMain()
            case .profile: TopItemProfile()
            }
        }
        .tabItem{
            Image(systemName: tabViewModel.image)
            Text(tabViewModel.tabItem.rawValue)
        }.tag(tabViewModel.id)
    }
}

struct TabItem_Previews: PreviewProvider {
    static var previews: some View {
        TabItem(tabViewModel: tabViewModelArr[1])
    }
}
