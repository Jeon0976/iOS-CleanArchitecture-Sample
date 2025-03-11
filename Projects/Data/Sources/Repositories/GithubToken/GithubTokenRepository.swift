//
//  GithubTokenRepository.swift
//  Data
//
//  Created by 전성훈 on 3/11/25.
//

import Foundation

import Domain

final class GithubTokenRepository: GithubTokenRepositoryInterface {
    private let networkSession: NetworkSession
    
    init(networkSession: NetworkSession = NetworkSession()) {
        self.networkSession = networkSession
    }
    
    func requestAccessToken(request: GithubTokenClientInfo) async throws -> GithubToken {
        let request = GithubAccessTokenRequest(clientId: request.clientId, clientSecret: request.clientSecret, code: request.code)
        
        return try await networkSession.request(GithubAuthAPI.requestAccessToken(request: request), type: GithubAccessTokenResponse.self).toDomain()
    }
}

