//
//  MockUserUseCase.swift
//  Presentation
//
//  Created by 전성훈 on 3/26/25.
//

import Foundation

import Domain

final class MockUserUseCase: UserUseCaseInterface {
    var shouldThrowError = false
    var mockUser: User?
    
    init() {
        // 기본 미리보기용 Mock 사용자 생성
        mockUser = User(
            id: 123456,
            name: "mockUser",
            poster: Data(),
            location: "seoul",
            followers: 200,
            following: 100
        )
    }
    
    func fetchUser() async throws -> User {
        if shouldThrowError {
            throw UserUseCaseError.tokenNotFound
        }
        
        guard let user = mockUser else {
            throw UserUseCaseError.tokenNotFound
        }
        
        return user
    }
    
    func logout() {}
}
