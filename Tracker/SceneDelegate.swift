//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Сергей Денисенко on 29.11.2023.
//

import UIKit
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        guard UserDefaults.standard.bool(forKey: "isHide") else {
            let onboardingPages = OnboardingViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
            window?.rootViewController = onboardingPages
            window?.makeKeyAndVisible()
            return
        }
        
        window?.rootViewController = TabBarController()
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}

