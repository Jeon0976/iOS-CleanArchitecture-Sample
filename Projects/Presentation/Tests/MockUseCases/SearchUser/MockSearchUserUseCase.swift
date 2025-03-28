//
//  MockSearchUserUseCase.swift
//  Presentation
//
//  Created by 전성훈 on 3/26/25.
//

import Foundation

import Domain

final class MockSearchUserUseCase: SearchUserUseCaseInterface {
    var currentQuery: String? = nil
    var hasNextPage: Bool = false
    var currentPage: Int = 1
    var totalPages: Int = 0
    var perPage: Int = 30
    
    var error: Error?
    var users: [GithubUser] = []
    var imageData = Data()
    
    var searchInitialUsersCalled = false
    var loadNextPageCalled = false
    var fetchUserImageCalled = false
    var resetSearchCalled = false
    
    func searchInitialUsers(query: String) async throws -> [GithubUser] {
        searchInitialUsersCalled = true
        
        if let error = error {
            throw error
        }
        
        return users
    }
    
    func loadNextPage() async throws -> [GithubUser] {
        loadNextPageCalled = true
        
        if let error = error {
            throw error
        }
        
        return users
    }
    
    func fetchUserImage(
        with imagePath: String,
        id: Int
    ) async throws -> Data {
        fetchUserImageCalled = true
        
        if let error = error {
            throw error
        }
        
        return imageData
    }
    
    func resetSearch() {
        resetSearchCalled = true
    }
}
