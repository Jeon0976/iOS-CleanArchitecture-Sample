//
//  GithubTokenCoordinator.swift
//  Presentation
//
//  Created by 전성훈 on 3/11/25.
//

import UIKit

public final class GithubTokenCoordinator: Coordinator {
    public var navigationController: UINavigationController
    
    public var childCoordinators: [Coordinator] = []
    public var viewControllerFactory: ViewControllerFactoryInterface

    public weak var finishDelegate:  CoordinatorFinishDelegate?
    
    public init(
        navigationController: UINavigationController,
        factory: ViewControllerFactoryInterface
    ) {
        self.navigationController = navigationController
        self.viewControllerFactory = factory
    }
    
    public func start() {
        
    }
    
    public func start(window: UIWindow) {
        let viewController = viewControllerFactory.makeGithubTokenViewController()
        
        viewController.viewModel.coordinator = self
        navigationController.pushViewController(
            viewController,
            animated: false
        )

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

extension GithubTokenCoordinator: GithubTokenCoordinatorActions {
    public func moveToRoot() {
        finishDelegate?.coordinatorDidFinish(self)
    }
}
