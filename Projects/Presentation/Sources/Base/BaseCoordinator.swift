//
//  BaseCoordinator.swift
//  Presentation
//
//  Created by 전성훈 on 3/11/25.
//

import UIKit

@MainActor
public protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    
    var childCoordinators: [Coordinator] { get set }
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    var viewControllerFactory: ViewControllerFactoryInterface { get }
    
    func start()
    func attachChild(_ coordinator: Coordinator)
    func detachChild(_ coordinator: Coordinator)
}

extension Coordinator {
    public func attachChild(_ coordinator: Coordinator) {
        if !childCoordinators.contains(where: { $0 === coordinator}) {
            childCoordinators.append(coordinator)
        }
    }
    
    public func detachChild(_ coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { $0 === coordinator}) {
            childCoordinators.remove(at: index)
        }
    }
}

@MainActor
public protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(_ coordinator: Coordinator)
}
