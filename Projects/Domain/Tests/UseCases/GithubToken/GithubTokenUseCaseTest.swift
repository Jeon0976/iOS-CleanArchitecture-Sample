//
//  GithubTokenUseCaseTest.swift
//  Domain
//
//  Created by 전성훈 on 3/11/25.
//

import XCTest

@testable import Domain

final class GithubTokenUseCaseTest: XCTestCase {
    private var mockTokenStorage: MockTokenStorage!
    private var mockGithubTokenRepository: MockGithubTokenRepository!
    
    private var sut: GithubTokenUsecase!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        mockTokenStorage = MockTokenStorage()
        mockGithubTokenRepository = MockGithubTokenRepository()
        sut = GithubTokenUsecase(
            tokenStorage: mockTokenStorage,
            githubTokenRepository: mockGithubTokenRepository
        )
    }
    
    override func tearDownWithError() throws {
        sut = nil
        
        mockTokenStorage = nil
        mockGithubTokenRepository = nil
        
        try super.tearDownWithError()
    }
    
    func test_requestCode() async throws {
        // given
        let expectedURL = mockGithubTokenRepository.testURL
        
        // when
        let requestURL = try await sut.requestCode()
        
        // then
        XCTAssertEqual(requestURL, expectedURL)
    }
    
    func test_fetchGithubToken() async throws {
        // given
        let testCode = "testCode"
        let exptecdToken = mockGithubTokenRepository.githubToken
        
        // when
        try await sut.fetchGithubToken(with: testCode)
        
        // then
        XCTAssertEqual(testCode, mockGithubTokenRepository.testCode)
    }
    
    func test_retriveToken() {
        // given
        let expectedToken = "token"
        mockTokenStorage.storedToken = expectedToken
        
        // when
        let result = sut.retriveToken()
        
        // then
        XCTAssertEqual(result, expectedToken)
    }
    
    func test_clearToken() {
        // when
        sut.clearToken()
        
        // then
        XCTAssertTrue(mockTokenStorage.cleared)
    }
}
