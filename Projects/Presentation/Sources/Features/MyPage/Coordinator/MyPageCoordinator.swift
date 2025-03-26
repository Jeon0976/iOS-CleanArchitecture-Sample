//
//  MyPageCoordinator.swift
//  Presentation
//
//  Created by 전성훈 on 3/13/25.
//

import UIKit

final class MyPageCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    var viewControllerFactory: ViewFactoryInterface
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    init(
        navigationController: UINavigationController,
        factory: ViewFactoryInterface
    ) {
        self.navigationController = navigationController
        self.viewControllerFactory = factory
    }
    
    func start() {
        let viewController = viewControllerFactory.makeMyPageViewController()
        
        viewController.viewModel.coordinator = self
        
        navigationController.pushViewController(
            viewController,
            animated: false
        )
    }
}

extension MyPageCoordinator: MyPageCoordinatorActions {
    func backToLogin() {
        finishDelegate?.coordinatorDidFinish(self)
    }
}
