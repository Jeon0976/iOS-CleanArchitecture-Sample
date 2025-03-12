//
//  GithubTokenViewModelTest.swift
//  PresentationTests
//
//  Created by 전성훈 on 3/12/25.
//

import XCTest
import Combine

@testable import Presentation

@MainActor
final class GithubTokenViewModelTest: XCTestCase {
    private var mockGithubTokenUseCase: MockGithubTokenUseCase!
    private var mockCoordinator: MockGithubTokenCoordinator!
    private var cancellables: Set<AnyCancellable>!
    
    private var input: GithubTokenViewInput!
    private var output: GithubTokenViewOutput!
    
    private let loginButtonSubject = PassthroughSubject<Void, Never>()
    
    private var sut: GithubTokenViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        mockGithubTokenUseCase = MockGithubTokenUseCase()
        mockCoordinator = MockGithubTokenCoordinator()
        sut = GithubTokenViewModel(githubTokenUseCase: mockGithubTokenUseCase)
        sut.coordinator = mockCoordinator
        
        cancellables = []
        
        input = GithubTokenViewInput(
            loginButtonTapped: loginButtonSubject.eraseToAnyPublisher()
        )
        
        output = sut.transform(input: input)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockGithubTokenUseCase = nil
        mockCoordinator = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_loginButtonTapped() {
        // given
        let expectedURL = mockGithubTokenUseCase.url
        
        var receivedURL: URL?
        var receivedError: Error?
        
        output.url
            .sink { url in
                receivedURL = url
            }
            .store(in: &cancellables)
        
        output.error
              .sink { error in
                  receivedError = error
              }
              .store(in: &cancellables)
        
        // when
        loginButtonSubject.send()
        
        // then
        XCTAssertEqual(receivedURL, expectedURL)
        XCTAssertNil(receivedError)
    }
}
