//
//  DIContainer.swift
//  DependencyInjection
//
//  Created by 전성훈 on 3/11/25.
//

import Foundation

final class DIContainer {
    static let shared = DIContainer()
    
    private var factories = [String: Any]()
    private var instances = [String: Any]()
    
    private init() { }
    
    func register<T>(_ factory: @escaping (() -> T)) {
        let ley = String(describing: T.self)
        
        factories[key] = factory
    }
    
    func register<T>(instance: T) {
        let key = String(describing: T.self)
        
        guard instances[key] == nil else {
            fatalError("\(key)가 이미 인스턴스에 저장되어 있습니다.")
            return
        }
        
        instances[key] = instance
    }
    
    func resolve<T>() -> T {
        let key = String(describing: T.self)
        
        if let instance = instances[key] as? T { return instance }
        
        if let factory = factories[key] as? () -> T {
            let instance = factory()
            
            return instance
        }
        
        fatalError("\(key)에 대한 인스턴스를 찾을 수 없습니다.")
    }
}
