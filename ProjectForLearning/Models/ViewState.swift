//
//  ViewState.swift
//  ProjectForLearning
//
//  Created by Евгений Карась on 1.02.23.
//

import Foundation

final class ViewState : ObservableObject {
    
    enum ContentViewState {
        case splash
        case greeting
        case signIn
        case signOut
    }
    
    @Published var contentViewState: ContentViewState =  .splash
}
