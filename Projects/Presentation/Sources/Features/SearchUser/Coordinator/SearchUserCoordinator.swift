//
//  SearchUserCoordinator.swift
//  Presentation
//
//  Created by 전성훈 on 3/12/25.
//

import UIKit

final class SearchUserCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    var viewControllerFactory: ViewControllerFactoryInterface
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    init(
        navigationController: UINavigationController,
        factory: ViewControllerFactoryInterface
    ) {
        self.navigationController = navigationController
        self.viewControllerFactory = factory
    }
    
    func start() {
        let viewController = viewControllerFactory.makeSearchUserViewController()
        
        viewController.viewModel.coordinator = self
        navigationController.pushViewController(
            viewController,
            animated: false
        )
    }
}

extension SearchUserCoordinator: SearchUserCoordinatorActions {
    func backToLogin() {
        finishDelegate?.coordinatorDidFinish(self)
    }
}
