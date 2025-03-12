//
//  SearchUserCoordinator.swift
//  Presentation
//
//  Created by 전성훈 on 3/12/25.
//

import UIKit

public final class SearchUserCoordinator: Coordinator {
    public var navigationController: UINavigationController
    
    public var childCoordinators: [Coordinator] = []
    public var viewControllerFactory: ViewControllerFactoryInterface

    public weak var finishDelegate: CoordinatorFinishDelegate?
    
    public init(
        navigationController: UINavigationController,
        factory: ViewControllerFactoryInterface
    ) {
        self.navigationController = navigationController
        self.viewControllerFactory = factory
    }
    
    public func start() {
        
    }
}
