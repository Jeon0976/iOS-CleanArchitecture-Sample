//
//  PosterImageRepositoryTest.swift
//  Data
//
//  Created by 전성훈 on 3/12/25.
//

import XCTest

import Domain

@testable import Data

final class PosterImageRepositoryTest: XCTestCase {
    private var mockCache: MockPosterStorage!
    private var mockNetworkSession: MockNetworkSession!
    
    private var sut: PosterImageRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        mockCache = MockPosterStorage(capacity: 100)
        mockNetworkSession = MockNetworkSession()
        
        sut = PosterImageRepository(
            networkSession: mockNetworkSession,
            cache: mockCache
        )
    }
    
    override func tearDownWithError() throws {
        sut = nil
        
        mockCache = nil
        
        try super.tearDownWithError()
    }
    
    func test_featch_success_when_cache_hit() async throws {
        // given
        let imageUrl = "test.jpg"
        let id = "1"
        let testData = "test".data(using: .utf8)!
        
        await mockCache.setData(key: id, value: testData)
        
        // when
        _ = try await sut.featchPoster(
            with: imageUrl,
            userID: id
        )
        
        // then
        XCTAssertTrue(mockCache.calledGetData)
        XCTAssertFalse(mockNetworkSession.requestCalled)
    }
}
