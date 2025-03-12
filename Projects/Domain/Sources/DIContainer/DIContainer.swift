//
//  DIContainer.swift
//  Domain
//
//  Created by 전성훈 on 3/11/25.
//

import DependencyInjection

final public class DomainDIContainer {
    static public let shared = DomainDIContainer()
    
    private let container = DIContainer.shared
    
    private init() {
        registerGithubTokenUseCase()
        registerSearchUserUseCase()
    }
    
    private func registerGithubTokenUseCase() {
        container.register {
            let githubTokenUseCase: GithubTokenUseCaseInterface = GithubTokenUseCase(
                tokenStorage: DIContainer.shared.resolve(),
                githubTokenRepository: DIContainer.shared.resolve()
            )
            
            return githubTokenUseCase
        }
    }
    
    private func registerSearchUserUseCase() {
        container.register {
            let searchUserUseCase: SearchUserUseCaseInterface = SearchUserUseCase(
                tokenStorage: DIContainer.shared.resolve(),
                searchUserRepository: DIContainer.shared.resolve(),
                posterImageRepository: DIContainer.shared.resolve()
            )
            
            return searchUserUseCase
        }
    }
}
