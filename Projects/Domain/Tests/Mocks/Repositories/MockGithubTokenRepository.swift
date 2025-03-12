//
//  MockGithubTokenRepository.swift
//  Domain
//
//  Created by 전성훈 on 3/11/25.
//

import Foundation

import Domain

final class MockGithubTokenRepository: GithubTokenRepositoryInterface {
    
    var error: Error = NSError(domain: "testError", code: 0)
    var testURL = URL(string: "test.com")!
    var isError = false
    
    var githubToken = GithubToken(
        token: "token",
        tokenType: "type"
    )
    
    var testCode: String?
    
    func requestCode() throws -> URL {
        
        if isError {
            throw error
        }
        
        
        return testURL
    }
    
    func requestAccessToken(
        with code: String
    ) async throws -> GithubToken {
        
        if isError {
            throw error
        }
        
        self.testCode = code
        
        return githubToken
    }
}
