//
//  GithubTokenRepositoryTest.swift
//  DataTests
//
//  Created by 전성훈 on 3/11/25.
//

import XCTest

import Domain

@testable import Data

final class GithubTokenRepositoryTest: XCTestCase {
    private var mockNetworkSession: MockNetworkSession!
    private var sut: GithubTokenRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        mockNetworkSession = MockNetworkSession()
        sut = GithubTokenRepository(networkSession: mockNetworkSession)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockNetworkSession = nil
        
        try super.tearDownWithError()
    }

    func test_requestAccessToken_success() async throws {
        // given
        let expectedToken = "test_token"
        let expectedType = "type"
        let expectedScope = "user"
        
        let response = GithubAccessTokenResponse(
            accessToken: expectedToken,
            tokenType: expectedType,
            scope: expectedScope
        )
        
        mockNetworkSession.response = response
        
        let clientInfo = GithubTokenClientInfo(
            clientId: "test_client_id",
            clientSecret: "test_client_secret",
            code: "test_code"
        )
        
        // when
        let result = try await sut.requestAccessToken(with: clientInfo.code)
        
        // then
        XCTAssertEqual(result.token, expectedToken)
        XCTAssertEqual(result.tokenType, expectedType)
    }
    
    func test_requestAccessToken_failure() async throws {
        // given
        mockNetworkSession.error = NetworkError.badConnection
         
         let clientInfo = GithubTokenClientInfo(
             clientId: "test_client_id",
             clientSecret: "test_client_secret",
             code: "test_code"
         )
         
         // when/then
         do {
             _ = try await sut.requestAccessToken(with: clientInfo.code)
             XCTFail("실패해야 함")
         } catch {
             XCTAssertEqual(error as? NetworkError, NetworkError.badConnection)
         }
    }
}
