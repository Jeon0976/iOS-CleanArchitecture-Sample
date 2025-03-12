//
//  SearchUserRepositoryInterface.swift
//  Domain
//
//  Created by 전성훈 on 3/11/25.
//

import Foundation

public protocol SearchUserRepositoryInterface {
    func fetchGithubUsers(
        query: GithubUserQuery,
        page: Int,
        perPage: Int,
        token: String
    ) async throws -> GithubUsersPage
}
