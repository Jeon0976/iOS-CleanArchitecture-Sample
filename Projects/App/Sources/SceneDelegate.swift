//
//  SceneDelegate.swift
//  GitSearch
//
//  Created by 전성훈 on 3/11/25.
//

import UIKit

import DependencyInjection
import Presentation
import Data
import Domain

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        print("AFAF")
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        print("AA")
        let window = UIWindow(windowScene: windowScene)

        let coordinator = GithubTokenCoordinator(
            navigationController: UINavigationController(),
            factory: ViewControllerFactory.shared
        )
        
        coordinator.start(window: window)

        self.window = window
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Scene이 해제될 때 호출
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // App이 활성화될 때 호출
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // App이 비활성화될 때 호출
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // App이 포그라운드로 들어갈 때 호출
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // App이 백그라운드로 들어갈 때 호출
    }
}
