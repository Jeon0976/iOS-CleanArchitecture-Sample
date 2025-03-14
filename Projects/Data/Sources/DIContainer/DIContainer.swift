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
        registerPersistantStorages()
        registerRepository()
    }
    
    private func registerNetworkSession() {
        let networkSession: NetworkSession = NetworkSession()

        container.register(instance: networkSession)
    }
    
    private func registerPersistantStorages() {
        let posterImageStorage: PosterImageStorageInterface = PosterLRUCacheStorage()
        
        let userStorage: UserStorageInterface = UserVolatileStorage()
        
        container.register(instance: posterImageStorage)
        container.register(instance: userStorage)
    }
    
    private func registerRepository() {
        let githubTokenRepository: GithubTokenRepositoryInterface = GithubTokenRepository(
            networkSession: container.resolve()
        )
                
        let searchUserRepository: SearchUserRepositoryInterface = SearchUserRepository(
            networkSession: container.resolve()
        )
        
        let posterImageRepository: PosterImageRepsitoryInterface = PosterImageRepository(
            networkSession: container.resolve(),
            cache: container.resolve()
        )
        
        let userRepository: UserRepositoryInterface = UserRepository(
            networkSession: container.resolve(),
            userStorage: container.resolve()
        )
        
        container.register(instance: githubTokenRepository)
        container.register(instance: searchUserRepository)
        container.register(instance: posterImageRepository)
        container.register(instance: userRepository)
    }
    
}
