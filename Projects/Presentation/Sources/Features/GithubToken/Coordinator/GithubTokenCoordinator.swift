//
//  GithubTokenCoordinator.swift
//  Presentation
//
//  Created by 전성훈 on 3/11/25.
//

import UIKit

final class GithubTokenCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    var viewControllerFactory: ViewControllerFactoryInterface

    weak var finishDelegate:  CoordinatorFinishDelegate?
    
    init(
        navigationController: UINavigationController,
        factory: ViewControllerFactoryInterface
    ) {
        self.navigationController = navigationController
        self.viewControllerFactory = factory
    }
    
    func start() {
        let viewController = viewControllerFactory.makeGithubTokenViewController()
        
        viewController.viewModel.coordinator = self
        navigationController.pushViewController(
            viewController,
            animated: false
        )
    }
    
    func start(window: UIWindow) {
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
    func moveToRoot() {
        finishDelegate?.coordinatorDidFinish(self)
    }
}
