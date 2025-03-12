//
//  ViewControllerFactory.swift
//  Presentation
//
//  Created by 전성훈 on 3/12/25.
//

import UIKit

import DependencyInjection

@MainActor
public protocol ViewControllerFactoryInterface {
    func makeGithubTokenViewController() -> GithubTokenViewController
}

public final class ViewControllerFactory: ViewControllerFactoryInterface {
    public static let shared = ViewControllerFactory()
    
    private init() { }
    
    private let container = DIContainer.shared
    
    public func makeGithubTokenViewController() -> GithubTokenViewController {
        let viewModel = GithubTokenViewModel(githubTokenUseCase: container.resolve())
        
        return GithubTokenViewController(viewModel: viewModel)
    }
}
