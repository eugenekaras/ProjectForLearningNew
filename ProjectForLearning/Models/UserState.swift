//
//  AuthenticationViewModel.swift
//  ProjectForLearning
//
//  Created by Евгений Карась on 21.01.23.
//

import Combine

class UserState: ObservableObject {
    
    enum State {
        case unknown
        case signedIn
        case signedOut
    }
    
    @Published var user: User = .emptyUser
    @Published var state: State = .unknown
}

