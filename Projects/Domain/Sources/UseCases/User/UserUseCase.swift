//
//  UserUseCase.swift
//  Domain
//
//  Created by 전성훈 on 3/13/25.
//

import Foundation

import Core

public enum UserUseCaseError: Error {
    case tokenNotFound
}

public protocol UserUseCaseInterface: AnyObject {
    func fetchUser() async throws -> User
}

final class UserUseCase: UserUseCaseInterface {
    
    private let tokenStorage: TokenStorage
    private let userRepository: UserRepositoryInterface
    
    init(
        tokenStorage: TokenStorage,
        userRepository: UserRepositoryInterface
    ) {
        self.tokenStorage = tokenStorage
        self.userRepository = userRepository
    }
    
    func fetchUser() async throws -> User {
        guard let token = tokenStorage.retrieve() else {
            throw UserUseCaseError.tokenNotFound
        }
        
        return try await userRepository.getUser(token: token)
    }
}
