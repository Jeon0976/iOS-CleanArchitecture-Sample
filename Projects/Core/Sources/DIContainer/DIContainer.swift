//
//  DIContainer.swift
//  Core
//
//  Created by 전성훈 on 3/11/25.
//

import DependencyInjection

public final class CoreDIContainer {
    static public let shared = CoreDIContainer()
    
    private let container = DIContainer.shared
    
    private init() {
        registerKeychainStorage()
    }
    
    private func registerKeychainStorage() {
        let userDefaultsTokenStorage: TokenStorage = UserDefaultsTokenStorage()
        
        container.register(instance: userDefaultsTokenStorage)
    }
}
