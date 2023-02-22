//
//  Container.swift
//  ProjectForLearning
//
//  Created by Sergei Bogachev on 22/02/2023.
//

import Factory

extension Container {
        
    static let authenticationService = Factory(scope: .singleton) { AuthenticationService() }
        
}
