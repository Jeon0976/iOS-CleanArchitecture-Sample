//
//  MockTokenStorage.swift
//  Domain
//
//  Created by 전성훈 on 3/11/25.
//

import Core

final class MockTokenStorage: TokenStorage {
    var storedToken: String?
    
    func store(token: String) {
        storedToken = token
    }
    
    func retrieve() -> String? {
        return storedToken
    }
    
    func clear() {
        storedToken = nil
    }
}
