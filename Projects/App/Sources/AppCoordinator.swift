//
//  AppCoordinator.swift
//  GitSearch
//
//  Created by 전성훈 on 3/13/25.
//  Copyright © 2025 com.gitsearch.iOS. All rights reserved.
//

import UIKit

import Core
import Presentation
import DependencyInjection


@MainActor
final class AppCoordinator {
    
    private var window: UIWindow!
    private let tokenStorage: TokenStorage
    
    var childCoordinators: [RootCoordinator] = []
    
    init(
        tokenStorage: TokenStorage = DIContainer.shared.resolve()
    ) {
        self.tokenStorage = tokenStorage
    }
    
    func launch(with window: UIWindow) {
        self.window = window
        checkToken(with: window)
    }
    
    private func checkToken(with window: UIWindow) {
        if (tokenStorage.retrieve() != nil) {
            showTabBar(with: window)
        } else {
            showTokenFeature(with: window)
        }
    }
    
    private func showTabBar(with window: UIWindow) {
        let tabBarCoordinator = TabBarCoordinator(
            tabBarController: UITabBarController()
        )
        
        tabBarCoordinator.rootFinishDelegate = self
        childCoordinators.append(tabBarCoordinator)
        
        tabBarCoordinator.launch(with: window)
    }
    
    private func showTokenFeature(with window: UIWindow) {
        let githubTokenCoordiantor = GithubTokenCoordinator(
            navigationController: UINavigationController()
        )
        
        githubTokenCoordiantor.rootFinishDelegate = self
        childCoordinators.append(githubTokenCoordiantor)
        
        githubTokenCoordiantor.launch(with: window)
    }
    
    func fetchGithubAccessToken(with code: String) {
        if let githubTokenCoordinator = childCoordinators.first(
            where: { $0 is GithubTokenCoordinator }
        ) as? GithubTokenCoordinator {
            githubTokenCoordinator.fetchGithubAccessToken(with: code)
        }
    }
}

extension AppCoordinator: RootCoordinatorDidFinishDelegate {
    func coordinatorDidFinish(_ coordinator: RootCoordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
        
        if coordinator is GithubTokenCoordinator {
            showTabBar(with: window)
        }
        
        if coordinator is TabBarCoordinator {
            showTokenFeature(with: window)
        }
    }
}
