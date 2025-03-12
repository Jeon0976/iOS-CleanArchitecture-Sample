//
//  DIContainer.swift
//  Data
//
//  Created by 전성훈 on 3/11/25.
//

import DependencyInjection

import Domain

public final class DataDIContainer {
    static public let shared = DataDIContainer()
    
    private let container = DIContainer.shared
    
    private init() {
        registerNetworkSession()
        registerRepository()
    }
    
    private func registerNetworkSession() {
        let networkSession: NetworkSession = NetworkSession()

        container.register(instance: networkSession)
    }
    
    private func registerRepository() {
        let githubTokenRepository: GithubTokenRepositoryInterface = GithubTokenRepository(
            networkSession: container.resolve()
        )
        
        container.register(instance: githubTokenRepository)
    }
}
