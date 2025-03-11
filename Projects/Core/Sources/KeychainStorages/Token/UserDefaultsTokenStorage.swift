//
//  UserDefaultsTokenStorage.swift
//  Core
//
//  Created by 전성훈 on 3/11/25.
//

import Foundation

// 실제 적용 앱에서는 keychain으로 활용
final class UserDefaultsTokenStorage: TokenStorage {
    private let userDefaults: UserDefaults
    private let tokenKey: String
    
    init(
        userDefaults: UserDefaults = .standard,
        tokenKey: String = "accessToken"
    ) {
        self.userDefaults = userDefaults
        self.tokenKey = tokenKey
    }
    
    func store(token: String) {
        userDefaults.set(token, forKey: tokenKey)
    }
    
    func retrieve() -> String? {
        return userDefaults.string(forKey: tokenKey)
    }
    
    func clear() {
        userDefaults.removeObject(forKey: tokenKey)
    }
}
