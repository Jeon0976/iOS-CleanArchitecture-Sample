//
//  MockSearchUserRepository.swift
//  Domain
//
//  Created by 전성훈 on 3/26/25.
//

import Foundation

import Domain

final class MockSearchUserRepository: SearchUserRepositoryInterface {
    var totalCount: Int = 0
    var expectedUsers: [GithubUser] = []
    
    var error: Error?
    
    func fetchGithubUsers(
        query: GithubUserQuery,
        page: Int,
        perPage: Int,
        token: String
    ) async throws -> GithubUsersPage {
        if let error = error {
            throw error
        }
        
        return GithubUsersPage(
            totalCount: totalCount,
            currentPage: page,
            users: expectedUsers
        )
    }
}
