//
//  UserRepository.swift
//  Data
//
//  Created by 전성훈 on 3/13/25.
//

import Foundation

import Domain

final class UserRepository: UserRepositoryInterface {
    
    private let networkSession: NetworkSession
    private let userStorage: UserStorageInterface
    
    init(
        networkSession: NetworkSession,
        userStorage: UserStorageInterface
    ) {
        self.networkSession = networkSession
        self.userStorage = userStorage
    }
    
    func getUser(token: String) async throws -> User {
        if let cachedUser = userStorage.loadUser() {
            return cachedUser
        }
        
        let userResponse = try await networkSession.request(
            UserAPI.getUser(token: token),
            type: UserResponse.self
        )
        
        let user = try await userResponse.toDomain()
        
        userStorage.saveUser(user)
        
        return user
    }
    
    func clearUser() {
        userStorage.clearUser()
    }
}
