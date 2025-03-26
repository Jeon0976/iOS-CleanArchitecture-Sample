//
//  MockGithubTokenUseCase.swift
//  Presentation
//
//  Created by 전성훈 on 3/26/25.
//

import Foundation

import Domain
import Core

final class MockGithubTokenUseCase: GithubTokenUseCaseInterface {
    var shouldThrowError = false
    var mockToken: String? = "mock-github-token-123456789"
    
    func requestCode() throws -> URL {
        if shouldThrowError {
            throw NSError(domain: "MockError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Mock error for requestCode"])
        }
        return URL(string: "https://github.com/login/oauth/authorize?client_id=mock_client_id&scope=user")!
    }
    
    func fetchGithubToken(with code: String) async throws {
        if shouldThrowError {
            throw NSError(
                domain: "MockError",
                code: 401,
                userInfo: [NSLocalizedDescriptionKey: "Mock error for fetchGithubToken"]
            )
        }
        // 미리보기에서는 토큰 저장하는 로직 생략
    }
    
    func retriveToken() -> String? {
        return mockToken
    }
    
    func clearToken() {
        mockToken = nil
    }
}
