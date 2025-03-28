//
//  SearchUserViewModelTests.swift
//  Presentation
//
//  Created by 전성훈 on 3/26/25.
//

import XCTest
import Combine

import Domain

@testable import Presentation

@MainActor
final class SearchUserViewModelTests: XCTestCase {
    private var mockSearchUseCase: MockSearchUserUseCase!
    private var mockCoordinator: MockSearchUserCoordinator!
    private var cancellables: Set<AnyCancellable>!
    
    private var input: SearchUserViewModelInput!
    private var output: SearchUserViewModelOutput!
    
    private let searchUserSubject = PassthroughSubject<String, Never>()
    private let loadNextPageSubject = PassthroughSubject<Void, Never>()
    private let backToLoginSubject = PassthroughSubject<Void, Never>()
    
    private var sut: SearchUserViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        mockSearchUseCase = MockSearchUserUseCase()
        mockCoordinator = MockSearchUserCoordinator()
        
        sut = SearchUserViewModel(searchUserUseCase: mockSearchUseCase)
        sut.coordinator = mockCoordinator
        
        cancellables = []
        
        input = SearchUserViewModelInput(
            searchUser: searchUserSubject.eraseToAnyPublisher(),
            loadNextPage: loadNextPageSubject.eraseToAnyPublisher(),
            backToLogin: backToLoginSubject.eraseToAnyPublisher()
        )
        
        output = sut.transform(input: input)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        
        mockCoordinator = nil
        mockSearchUseCase = nil
        cancellables = nil
        
        try super.tearDownWithError()
    }
    
    func test_SearchUser_when_success() async {
        // given
        let expectation = XCTestExpectation(description: "SearchUser success")
        var receivedUsers: [SearchUserItemViewModel] = []
        var loadingValues: [loadingType] = []
        
        output.users
            .sink { users in
                receivedUsers = users
                if !users.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        output.isLoading
            .sink { loadingState in
                loadingValues.append(loadingState)
            }
            .store(in: &cancellables)
        
        let testUsers = [
            GithubUser(
                id: 1,
                name: "user1",
                posterPath: "user1Poster",
                url: URL(string: "url")!
            ),
            GithubUser(
                id: 2,
                name: "user1",
                posterPath: "user1Poster",
                url: URL(string: "url")!
            )
        ]
        mockSearchUseCase.users = testUsers
        
        // when
        searchUserSubject.send("test")
        
        await fulfillment(of: [expectation], timeout: 1.0)
        
        // then
        XCTAssertTrue(mockSearchUseCase.searchInitialUsersCalled)
        XCTAssertEqual(receivedUsers.count, 2)
        XCTAssertEqual(receivedUsers[0].user.id, 1)
        XCTAssertEqual(receivedUsers[1].user.id, 2)
        
        XCTAssertEqual(loadingValues.count, 3)
        XCTAssertEqual(loadingValues[1].type, .fullScreen)
        XCTAssertTrue(loadingValues[1].isLoading)
        XCTAssertEqual(loadingValues[2].type, .fullScreen)
        XCTAssertFalse(loadingValues[2].isLoading)
        
    }
    
    func test_loadNextPage_when_success() async {
        // given
        let initialSearchExpectation = XCTestExpectation(description: "InitialSearch Success")
        let nextPageExpectation = XCTestExpectation(description: "LoadNextPage Success")
        var receivedUsers: [SearchUserItemViewModel] = []
        var loadingValues: [loadingType] = []
        
        output.users
            .sink { users in
                receivedUsers = users
                
                if users.count == 1 {
                    initialSearchExpectation.fulfill()
                } else if users.count > 1 {
                    nextPageExpectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        output.isLoading
            .sink { loadingState in
                loadingValues.append(loadingState)
            }
            .store(in: &cancellables)
        
        // when
        // 첫 번째 검색 실행
        let initialUsers = [
            GithubUser(
                id: 1,
                name: "user1",
                posterPath: "user1Poster",
                url: URL(string: "url")!
            )
        ]
        mockSearchUseCase.users = initialUsers
        searchUserSubject.send("test")
        
        await fulfillment(of: [initialSearchExpectation], timeout: 1.0)
        
        // 두 번째 검색 실행
        let nextPageUsers = [
            GithubUser(
                id: 2,
                name: "user2",
                posterPath: "user2Poster",
                url: URL(string: "url")!
            )
        ]
        mockSearchUseCase.users = nextPageUsers
        mockSearchUseCase.hasNextPage = true
        loadNextPageSubject.send(())
        
        await fulfillment(of: [nextPageExpectation], timeout: 1.0)
        
        // then
        XCTAssertTrue(mockSearchUseCase.loadNextPageCalled)
        XCTAssertEqual(receivedUsers.count, 2)
        
        XCTAssertEqual(loadingValues.count, 5)
        XCTAssertEqual(loadingValues[3].type, .nextPage)
        XCTAssertTrue(loadingValues[3].isLoading)
        XCTAssertEqual(loadingValues[4].type, .nextPage)
        XCTAssertFalse(loadingValues[4].isLoading)
    }
    
    func test_backToLogin_when_success() {
        // when
        backToLoginSubject.send(())
        
        // then
        XCTAssertTrue(mockCoordinator.backToLoginCalled)
    }
}
