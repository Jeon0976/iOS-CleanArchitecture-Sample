//
//  UserVolatileStorage.swift
//  Data
//
//  Created by 전성훈 on 3/13/25.
//

import Foundation

import Domain

public final class UserVolatileStorage: UserStorageInterface {
    
    var user: User?
    
    public func saveUser(_ user: User) {
        self.user = user
    }

    public func loadUser() -> User? {
        return user
    }
}
