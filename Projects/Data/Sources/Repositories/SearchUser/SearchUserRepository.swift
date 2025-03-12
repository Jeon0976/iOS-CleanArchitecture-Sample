//
//  SearchUserRepository.swift
//  Data
//
//  Created by 전성훈 on 3/12/25.
//

import Foundation

import Domain

final class SearchUserRepository: SearchUserRepositoryInterface {
    
    private let networkSession: NetworkSession
    
    init(networkSession: NetworkSession) {
        self.networkSession = networkSession
    }
    
    func fetchGithubUsers(
        query: GithubUserQuery,
        page: Int,
        perPage: Int,
        token: String
    ) async throws -> GithubUsersPage {
        let request = SearchUserRequest(
            query: query.q,
            page: page,
            perPage: perPage
        )
        
        return try await networkSession.request(
            SearchUserAPI.requestUsers(
                requset: request,
                token: token
            ),
            type: SearchUsersResponse.self
        ).toDomain(currentPage: page)
    }
}
