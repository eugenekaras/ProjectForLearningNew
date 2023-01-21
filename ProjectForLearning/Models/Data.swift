//
//  Data.swift
//  ProjectForLearning
//
//  Created by Евгений Карась on 20.01.23.
//

import Foundation
import SwiftUI
import UIKit

enum Tabs: String {
    case someView = "Some View"
    case main = "Main"
    case profile = "Profile"
}

struct TabViewModel:Identifiable {
    var id: Int
    var tabItem: Tabs
    var image: String
}

let tabViewModelArr: [TabViewModel] = [TabViewModel(id: 1,tabItem: .someView  , image: "square.dashed"),
                                       TabViewModel(id: 2,tabItem: .main, image: "app"),
                                       TabViewModel(id: 3,tabItem: .profile, image: "person.fill")]


