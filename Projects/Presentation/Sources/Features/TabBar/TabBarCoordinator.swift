//
//  TabBarCoordinator.swift
//  Presentation
//
//  Created by 전성훈 on 3/13/25.
//

import UIKit

@MainActor
public final class TabBarCoordinator: RootCoordinator {
    var childCoordinators: [Coordinator] = []
    
    private let tabBarController: UITabBarController
    
    weak public var rootFinishDelegate: RootCoordinatorDidFinishDelegate?

    public init(
        tabBarController: UITabBarController
    ) {
        self.tabBarController = tabBarController
    }
    
    public func launch(with window: UIWindow) {
        setupTabs()
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
    
    
    public func fetchGithubAccessToken(with code: String) { }
    
    func attachChild(_ coordinator: Coordinator) {
        if !childCoordinators.contains(where: { $0 === coordinator}) {
            childCoordinators.append(coordinator)
        }
    }
    
    func detachChild(_ coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { $0 === coordinator}) {
            childCoordinators.remove(at: index)
        }
    }
    
    private func setupTabs() {
        let searchCoordinator = makeSearchCoordinator()
        let myPageCoordinator = makeMyPageCoordinator()
        
        searchCoordinator.start()
        myPageCoordinator.start()
        searchCoordinator.finishDelegate = self
        myPageCoordinator.finishDelegate = self
        
        searchCoordinator.navigationController.tabBarItem = UITabBarItem(
            title: "검색",
            image: nil,
            tag: 0
        )
        myPageCoordinator.navigationController.tabBarItem = UITabBarItem(
            title: "마이페이지",
            image: nil,
            tag: 0
        )
        
        attachChild(searchCoordinator)
        attachChild(myPageCoordinator)
        
        tabBarController.setViewControllers(
            [
                searchCoordinator.navigationController,
                myPageCoordinator.navigationController
            ],
            animated: false
        )
    }
    
    private func makeSearchCoordinator() -> SearchUserCoordinator {
        let navigationController = UINavigationController()
        
        return SearchUserCoordinator(
            navigationController: navigationController,
            factory: ViewControllerFactory.shared
        )
    }
    
    private func makeMyPageCoordinator() -> MyPageCoordinator {
        let navigationController = UINavigationController()
        
        return MyPageCoordinator(
            navigationController: navigationController,
            factory: ViewControllerFactory.shared
        )
    }
}

extension TabBarCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(_ coordinator: Coordinator) {
        childCoordinators.removeAll()
        rootFinishDelegate?.coordinatorDidFinish(self)
    }
}
