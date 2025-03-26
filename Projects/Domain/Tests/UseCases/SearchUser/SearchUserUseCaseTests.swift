//
//  SearchUserUseCaseTests.swift
//  Domain
//
//  Created by 전성훈 on 3/26/25.
//

import XCTest

@testable import Domain

final class SearchUserUseCaseTests: XCTestCase {
    private var mockTokenStorage: MockTokenStorage!
    private var mockSearchRepository: MockSearchUserRepository!
    private var mockPosterRepository: MockPosterImageRepository!
    
    private var sut: SearchUserUseCase!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        mockTokenStorage = MockTokenStorage()
        mockSearchRepository = MockSearchUserRepository()
        mockPosterRepository = MockPosterImageRepository()
        
        sut = SearchUserUseCase(
            tokenStorage: mockTokenStorage,
            searchUserRepository: mockSearchRepository,
            posterImageRepository: mockPosterRepository
        )
    }
    
    override func tearDownWithError() throws {
        sut = nil
        
        mockTokenStorage = nil
        mockSearchRepository = nil
        mockPosterRepository = nil
        
        try super.tearDownWithError()
    }
    
    func test_searchInitialUsers_success() async throws {
        // given
        mockTokenStorage.storedToken = "test_token"
        
        let expectedUsers = [
            GithubUser(
                id: 1,
                name: "user1",
                posterPath: "poster1",
                url: URL(string: "url1")!
            ),
            GithubUser(
                id: 2,
                name: "user2",
                posterPath: "poster2",
                url: URL(string: "url2")!
            )
        ]
        
        mockSearchRepository.totalCount = 2
        mockSearchRepository.expectedUsers = expectedUsers
        
        // when
        let users = try await sut.searchInitialUsers(query: "test")
        
        // then
        XCTAssertEqual(users.count, 2)
        XCTAssertEqual(users[0].id, 1)
        XCTAssertEqual(users[1].id, 2)
        XCTAssertEqual(sut.currentQuery, "test")
        XCTAssertEqual(sut.currentPage, 1)
        XCTAssertEqual(sut.totalPages, 1)
        XCTAssertFalse(sut.hasNextPage)
    }
    
    func test_searchInitialUsers_tokenNotFound() async {
        // given
        mockTokenStorage.storedToken = nil
        
        // when / then
        do {
            _ = try await sut.searchInitialUsers(query: "test")
        } catch {
            XCTAssertEqual(error as? SearchUserUseCaseError, .tokenNotFound)
        }
    }
    
    func test_loadNextPage_success() async throws {
        // given
        mockTokenStorage.storedToken = "test_token"
        sut.currentQuery = "test"
        sut.hasNextPage = true
        sut.currentPage = 1
        
        let expectedUsers = [
            GithubUser(
                id: 1,
                name: "user1",
                posterPath: "poster1",
                url: URL(string: "url1")!
            ),
            GithubUser(
                id: 2,
                name: "user2",
                posterPath: "poster2",
                url: URL(string: "url2")!
            )
        ]
        
        mockSearchRepository.totalCount = 100
        mockSearchRepository.expectedUsers = expectedUsers
        
        // when
        let users = try await sut.loadNextPage()
        
        // then
        XCTAssertEqual(users.count, 2)
        XCTAssertEqual(users[0].id, 1)
        XCTAssertEqual(sut.currentPage, 2)
        XCTAssertEqual(sut.totalPages, 4)
        XCTAssertTrue(sut.hasNextPage)
    }
    
    func test_loadNextPage_tokenNotFound() async {
        // given
        mockTokenStorage.storedToken = nil
        
        // when / then
        do {
            _ = try await sut.loadNextPage()
        } catch {
            XCTAssertEqual(error as? SearchUserUseCaseError, .tokenNotFound)
        }
    }
    
    func test_loadNextPage_queryMissing() async {
        // given
        mockTokenStorage.storedToken = "test_token"
        sut.currentQuery = nil
        
        // when / then
        do {
            _ = try await sut.loadNextPage()
        } catch {
            XCTAssertEqual(error as? SearchUserUseCaseError, .queryMissing)
        }
    }
    
    func test_loadNextPage_noNextPage() async {
        // given
        mockTokenStorage.storedToken = "test_token"
        sut.currentQuery = "test"
        sut.hasNextPage = false
        
        // when / then
        do {
            _ = try await sut.loadNextPage()
        } catch {
            XCTAssertEqual(error as? SearchUserUseCaseError, .noNextPage)
        }
    }
    
    func test_fetchUserImage_success() async throws {
        // given
        let imagePath = "https://testImage.com"
        let userId = 123
        let expectedData = "image_data".data(using: .utf8)!
        
        mockPosterRepository.imageData = expectedData
        
        // when
        let data = try await sut.fetchUserImage(with: imagePath, id: userId)

        // then
        XCTAssertEqual(data, expectedData)
    }
    
    func test_resetSearch() {
        // given
        sut.currentQuery = "test"
        sut.hasNextPage = true
        sut.currentPage = 3
        sut.totalPages = 5
        
        // when
        sut.resetSearch()
        
        // Then
        XCTAssertNil(sut.currentQuery)
        XCTAssertFalse(sut.hasNextPage)
        XCTAssertEqual(sut.currentPage, 1)
        XCTAssertEqual(sut.totalPages, 0)
    }
}
