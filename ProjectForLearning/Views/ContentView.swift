//
//  ContentView.swift
//  ProjectForLearning
//
//  Created by Евгений Карась on 18.01.23.
//

import SwiftUI

struct ContentView: View {
    
    @State var isError = false
    
    var body: some View {

        VStack {
//            Button("Crash") {
//                fatalError("Crash was triggered")
//            }
            TabPanelView(tabItems: tabViewModelArr)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
