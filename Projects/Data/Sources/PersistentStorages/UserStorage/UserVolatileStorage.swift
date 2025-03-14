//
//  UserVolatileStorage.swift
//  Data
//
//  Created by 전성훈 on 3/13/25.
//

import Foundation

import Domain

final class UserVolatileStorage: UserStorageInterface {
    var user: User?
    
    func saveUser(_ user: User) {
        self.user = user
    }

    func loadUser() -> User? {
        return user
    }
    
    func clearUser() {
        self.user = nil
    }
}
