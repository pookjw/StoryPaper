//
//  SceneDelegate.swift
//  StoryPaper_iOS
//
//  Created by Jinwoo Kim on 12/12/22.
//

import UIKit

@MainActor
final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene: UIWindowScene = scene as? UIWindowScene else {
            return
        }
        
        let window: UIWindow = .init(windowScene: windowScene)
        let rootViewController: MainViewController = .init()
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        self.window = window
    }
}
