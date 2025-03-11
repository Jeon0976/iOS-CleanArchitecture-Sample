//
//  DIContainer.swift
//  Data
//
//  Created by 전성훈 on 3/11/25.
//

import DependencyInjection

final class DataDIContainer {
    static public let shared = DataDIContainer()
    
    private let container = DIContainer.shared
    
    private init() {
        registerNetworkSession()
        registerRepository()
    }
    
    private func registerNetworkSession() {
        let networkSession = NetworkSession()
        
        container.register(instance: networkSession)
    }
    
    private func registerRepository() {
        let githubTokenRepository = GithubTokenRepository(
            networkSession: container.resolve()
        )
        
        container.register(instance: githubTokenRepository)
    }
}
