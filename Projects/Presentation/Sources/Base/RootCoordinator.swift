//
//  AppCoordinatorDidFinishDelegate.swift
//  Presentation
//
//  Created by 전성훈 on 3/13/25.
//

import UIKit

@MainActor
public protocol RootCoordinator: AnyObject {
    var rootFinishDelegate: RootCoordinatorDidFinishDelegate? { get set }
    func launch(with window: UIWindow)
    func fetchGithubAccessToken(with code: String) 
}

@MainActor
public protocol RootCoordinatorDidFinishDelegate: AnyObject {
    func coordinatorDidFinish(_ coordinator: RootCoordinator)
}
