//
//  SearchUserRepositoryTest.swift
//  Data
//
//  Created by 전성훈 on 3/12/25.
//

import XCTest

import Domain

@testable import Data

final class SearchUserRepositoryTest: XCTestCase {
    private var mockNetworkSession: MockNetworkSession!
    
    private var sut: SearchUserRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        mockNetworkSession = MockNetworkSession()
        
        sut = SearchUserRepository(
            networkSession: mockNetworkSession
        )
    }
    
    override func tearDownWithError() throws {
        sut = nil
        
        mockNetworkSession = nil
        
        try super.tearDownWithError()
    }
    
    func test_fetch_Github_Users() async throws {
        // given
        let query = GithubUserQuery(q: "test")
        let page = 1
        let perPage = 30
        let token = "test_token"
        
        let expectedUsers = [
            SearchUserResponse(
                id: 1,
                name: "testUser1",
                url: "https://github.com/testUser1",
                imagePath: "https://example.com/avatar1.png"
            ),
            SearchUserResponse(
                id: 2,
                name: "testUser2",
                url: "https://github.com/testUser2",
                imagePath: "https://example.com/avatar2.png"
            ),
        ]
        
        let expectedResponse = SearchUsersResponse(
            totalCount: 2,
            users: expectedUsers
        )
        
        mockNetworkSession.response = expectedResponse
        
        // when
        let result = try await sut.fetchGithubUsers(
            query: query,
            page: page,
            perPage: perPage,
            token: token
        )
        
        // then
        XCTAssertTrue(mockNetworkSession.requestCalled)
        XCTAssertEqual(result.users.count, 2)
        XCTAssertEqual(result.users[0].id, 1)
        XCTAssertEqual(result.users[1].id, 2)
    }
    
    func test_fetch_Github_EmptyUser() async throws {
        // given
        let query = GithubUserQuery(q: "test")
        let page = 1
        let perPage = 30
        let token = "test_token"
        
        
        let expectedResponse = SearchUsersResponse(
            totalCount: 0,
            users: []
        )
        
        mockNetworkSession.response = expectedResponse
        
        // when
        let result = try await sut.fetchGithubUsers(
            query: query,
            page: page,
            perPage: perPage,
            token: token
        )
        
        // then
        XCTAssertTrue(mockNetworkSession.requestCalled)
        XCTAssertEqual(result.users.count, 0)
    }
}
