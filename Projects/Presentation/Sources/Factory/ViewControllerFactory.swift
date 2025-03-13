//
//  ViewControllerFactory.swift
//  Presentation
//
//  Created by 전성훈 on 3/12/25.
//

import UIKit

import DependencyInjection

@MainActor
protocol ViewControllerFactoryInterface {
    func makeGithubTokenViewController() -> GithubTokenViewController
    func makeSearchUserViewController() -> SearchUserViewController
}

final class ViewControllerFactory: ViewControllerFactoryInterface {
    static let shared = ViewControllerFactory()
    
    private init() { }
    
    private let container = DIContainer.shared
    
    func makeGithubTokenViewController() -> GithubTokenViewController {
        let viewModel = GithubTokenViewModel(githubTokenUseCase: container.resolve())
        
        return GithubTokenViewController(viewModel: viewModel)
    }
    
    func makeSearchUserViewController() -> SearchUserViewController {
        let viewModel = SearchUserViewModel(searchUserUseCase: container.resolve())
        
        return SearchUserViewController(viewModel: viewModel)
    }
}
