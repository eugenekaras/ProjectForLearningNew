//
//  AppDelegate.swift
//  ProjectForLearning
//
//  Created by Евгений Карась on 18.01.23.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication
                     .LaunchOptionsKey: Any]?) -> Bool {
    // Initialize Firebase service.
    FirebaseApp.configure()
    return true
  }
}
