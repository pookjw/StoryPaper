//
//  AppDelegate.swift
//  StoryPaper_iOS
//
//  Created by Jinwoo Kim on 12/12/22.
//

import UIKit

@main
@MainActor
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let configuration: UISceneConfiguration = .init(name: nil, sessionRole: connectingSceneSession.role)
        configuration.sceneClass = UIWindowScene.self
        configuration.delegateClass = SceneDelegate.self
        return configuration
    }
}
