//
//  DIContainer.swift
//  Core
//
//  Created by 전성훈 on 3/11/25.
//

import DependencyInjection

final class CoreDIContainer {
    static public let shared = CoreDIContainer()
    
    private let container = DIContainer.shared
    
    private init() {
        registerKeychainStorage()
    }
    
    private func registerKeychainStorage() {
        let userDefaultsTokenStorage = UserDefaultsTokenStorage()
        
        container.register(instance: userDefaultsTokenStorage)
    }
}
