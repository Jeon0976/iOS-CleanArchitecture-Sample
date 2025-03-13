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
        let testViewController = UIViewController()
        testViewController.view.backgroundColor = .red
        
        navigationController.pushViewController(testViewController, animated: true)
    }
}
