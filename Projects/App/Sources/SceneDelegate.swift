//
//  SceneDelegate.swift
//  GitSearch
//
//  Created by 전성훈 on 3/11/25.
//

import UIKit


final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private var appCoordinator: AppCoordinator!
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)

        let coordinator = AppCoordinator()
        
        coordinator.launch(with: window)
        
        self.appCoordinator = coordinator
        self.window = window
    }
    
    func scene(
        _ scene: UIScene,
        openURLContexts URLContexts: Set<UIOpenURLContext>
    ) {
        if let url = URLContexts.first?.url {
            if url.absoluteString.starts(with: "findusername://"),
               let code = url.absoluteString
                .split(separator: "=")
                .last
                .map({ String($0)})
            {
                appCoordinator.fetchGithubAccessToken(with: code)
            }
        }
    }
}
