//
//  MockGithubTokenUseCase.swift
//  Presentation
//
//  Created by 전성훈 on 3/12/25.
//

import Foundation

import Domain

final class MockGithubTokenUseCase: GithubTokenUseCaseInterface {
    
    var url = URL(string:"https://github.com/")!
    var error: Error?
    var fetchGithubTokenCalled = false
    var token: String?
    
    func requestCode() throws -> URL {
        if let error = error {
            throw error
        }
        
        return url
    }
    
    func fetchGithubToken(with code: String) async throws {
        fetchGithubTokenCalled = true
        
        if let error = error {
            throw error
        }
    }
    
    func retriveToken() -> String? {
        return token
    }
    
    func clearToken() {
        token = nil
    }
}
