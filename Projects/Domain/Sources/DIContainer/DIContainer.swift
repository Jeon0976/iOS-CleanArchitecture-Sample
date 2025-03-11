//
//  DIContainer.swift
//  Domain
//
//  Created by 전성훈 on 3/11/25.
//

import DependencyInjection

final class DomainDIContainer {
    static public let shared = DomainDIContainer()
    
    private let container = DIContainer.shared
    
    private init() {
        registerGithubTokenUsecase()
    }
    
    private func registerGithubTokenUsecase() {
        container.register {
            GithubTokenUsecase(
                tokenStorage: DIContainer.shared.resolve(),
                githubTokenRepository: DIContainer.shared.resolve()
            )
        }
    }
}
