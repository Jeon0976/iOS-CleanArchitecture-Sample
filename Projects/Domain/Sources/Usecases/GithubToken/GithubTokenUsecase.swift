//
//  GithubTokenUsecase.swift
//  Domain
//
//  Created by 전성훈 on 3/11/25.
//

import Foundation

import Core

protocol GithubTokenUseCaseInterface: AnyObject {
    func requestCode() async throws -> URL
    func fetchGithubToken(with code: String) async throws
    func retriveToken() -> String?
    func clearToken()
}

final class GithubTokenUsecase: GithubTokenUseCaseInterface {
    private let tokenStorage: TokenStorage
    private let githubTokenRepository: GithubTokenRepositoryInterface
    
    init(
        tokenStorage: TokenStorage,
        githubTokenRepository: GithubTokenRepositoryInterface
    ) {
        self.tokenStorage = tokenStorage
        self.githubTokenRepository = githubTokenRepository
    }
    
    func requestCode() async throws -> URL {
        return try await githubTokenRepository.requestCode()
    }
    
    func fetchGithubToken(with code: String) async throws {
        let token = try await githubTokenRepository.requestAccessToken(with: code)
        
        tokenStorage.store(token: token.token)
    }
    
    func retriveToken() -> String? {
        return tokenStorage.retrieve()
    }
    
    func clearToken() {
        tokenStorage.clear()
    }
}
