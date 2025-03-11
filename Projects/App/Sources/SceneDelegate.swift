//
//  SceneDelegate.swift
//  MAJU
//
//  Created by 전성훈 on 3/5/25.
//  Copyright © 2025 com.maju. All rights reserved.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.overrideUserInterfaceStyle = .light
                
        window.rootViewController = UIViewController()
        window.makeKeyAndVisible()
        
        self.window = window
    }
}
