//
//  GithubTokenUsecase.swift
//  Domain
//
//  Created by 전성훈 on 3/11/25.
//

import Foundation

import Core

public protocol GithubTokenUseCaseInterface: AnyObject {
    func requestCode() throws -> URL
    func fetchGithubToken(with code: String) async throws
    func retriveToken() -> String?
    func clearToken()
}
 
final class GithubTokenUseCase: GithubTokenUseCaseInterface {
    private let tokenStorage: TokenStorage
    private let githubTokenRepository: GithubTokenRepositoryInterface
    
    init(
        tokenStorage: TokenStorage,
        githubTokenRepository: GithubTokenRepositoryInterface
    ) {
        self.tokenStorage = tokenStorage
        self.githubTokenRepository = githubTokenRepository
    }
    
    public func requestCode() throws -> URL {
        return try githubTokenRepository.requestCode()
    }
    
    public func fetchGithubToken(with code: String) async throws {
        let token = try await githubTokenRepository.requestAccessToken(with: code)
        
        tokenStorage.store(token: token.token)
    }
    
    public func retriveToken() -> String? {
        return tokenStorage.retrieve()
    }
    
    public func clearToken() {
        tokenStorage.clear()
    }
}
