//
//  GithubTokenCoordinator.swift
//  Presentation
//
//  Created by 전성훈 on 3/11/25.
//

import UIKit

import Shared

public final class GithubTokenCoordinator: Coordinator, RootCoordinator {
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    var viewControllerFactory: ViewControllerFactoryInterface

    weak var finishDelegate:  CoordinatorFinishDelegate?
    weak public var rootFinishDelegate: RootCoordinatorDidFinishDelegate?

    private var viewController: GithubTokenViewController?
    
    public init(
        navigationController: UINavigationController
    ) {
        self.navigationController = navigationController
        self.viewControllerFactory = ViewControllerFactory.shared
    }
    
    init(
        navigationController: UINavigationController,
        factory: ViewControllerFactoryInterface
    ) {
        self.navigationController = navigationController
        self.viewControllerFactory = factory
    }
    
    public func launch(with window: UIWindow) {
        let viewController = viewControllerFactory.makeGithubTokenViewController()

        self.viewController = viewController
        
        viewController.viewModel.coordinator = self
        navigationController.pushViewController(
            viewController,
            animated: false
        )
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func start() {}
    
    public func fetchGithubAccessToken(with code: String) {
        viewController?.redirectCode.send(code)
    }
}

extension GithubTokenCoordinator: GithubTokenCoordinatorActions {
    public func moveToRoot() {
        rootFinishDelegate?.coordinatorDidFinish(self)
    }
}
