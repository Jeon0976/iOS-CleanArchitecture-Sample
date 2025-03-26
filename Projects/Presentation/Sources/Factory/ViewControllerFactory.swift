//
//  ViewControllerFactory.swift
//  Presentation
//
//  Created by 전성훈 on 3/12/25.
//

import UIKit

import DependencyInjection

@MainActor
protocol ViewFactoryInterface {
    // SwiftUI Views
    func makeGithubTokenView() -> GithubTokenView
    
    // UIKit ViewControllers
    func makeGithubTokenViewController() -> GithubTokenViewController
    func makeSearchUserViewController() -> SearchUserViewController
    func makeMyPageViewController() -> MyPageViewController
}

final class ViewControllerFactory: ViewFactoryInterface {
    static let shared = ViewControllerFactory()
    
    private init() { }
    
    private let container = DIContainer.shared
    
    func makeGithubTokenView() -> GithubTokenView {
        let viewModel = GithubTokenViewModel(githubTokenUseCase: container.resolve())
        
        return GithubTokenView(viewModel: viewModel)
    }
    
    func makeGithubTokenViewController() -> GithubTokenViewController {
        let viewModel = GithubTokenViewModel(githubTokenUseCase: container.resolve())
        
        return GithubTokenViewController(viewModel: viewModel)
    }
    
    func makeSearchUserViewController() -> SearchUserViewController {
        let viewModel = SearchUserViewModel(searchUserUseCase: container.resolve())
        
        return SearchUserViewController(viewModel: viewModel)
    }
    
    func makeMyPageViewController() -> MyPageViewController {
        let viewModel = MyPageViewModel(userUseCase: container.resolve())
        
        return MyPageViewController(viewModel: viewModel)
    }
}
