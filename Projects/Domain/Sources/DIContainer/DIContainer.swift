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
        registerUserUseCase()
    }
    
    private func registerGithubTokenUseCase() {
        container.register(GithubTokenUseCaseInterface.self) {
            let githubTokenUseCase: GithubTokenUseCaseInterface = GithubTokenUseCase(
                tokenStorage: DIContainer.shared.require(),
                githubTokenRepository: DIContainer.shared.require()
            )
            
            return githubTokenUseCase
        }
    }
    
    private func registerSearchUserUseCase() {
        container.register(SearchUserUseCaseInterface.self) {
            let searchUserUseCase: SearchUserUseCaseInterface = SearchUserUseCase(
                tokenStorage: DIContainer.shared.require(),
                searchUserRepository: DIContainer.shared.require(),
                posterImageRepository: DIContainer.shared.require()
            )
            
            return searchUserUseCase
        }
    }
    
    private func registerUserUseCase() {
        container.register(UserUseCaseInterface.self) {
            let userUseCase: UserUseCaseInterface = UserUseCase(
                tokenStorage: DIContainer.shared.require(),
                userRepository: DIContainer.shared.require()
            )
            
            return userUseCase
        }
    }
}
