//
//  SearchUserUseCase.swift
//  Domain
//
//  Created by 전성훈 on 3/12/25.
//

import Foundation

import Core

public enum SearchUserUseCaseError: Error {
    case tokenNotFound
    case noNextPage
    case queryMissing
}

public protocol SearchUserUseCaseInterface: AnyObject {
    var currentQuery: String? { get }
    var hasNextPage: Bool { get }
    var currentPage: Int { get }
    var totalPages: Int { get }
    var perPage: Int { get }
    
    func searchInitialUsers(query: String) async throws -> [GithubUser]
    func loadNextPage() async throws -> [GithubUser]
    func fetchUserImage(with imagePath: String, id: Int) async throws -> Data
    func resetSearch()
}

final class SearchUserUseCase: SearchUserUseCaseInterface {
    private let tokenStorage: TokenStorage
    private let searchUserRepository: SearchUserRepositoryInterface
    private let posterImageRepository: PosterImageRepsitoryInterface
    
    var currentQuery: String? = nil
    var hasNextPage: Bool = false
    var currentPage: Int = 1
    var totalPages: Int = 0
    var perPage: Int = 30
    
    init(
        tokenStorage: TokenStorage,
        searchUserRepository: SearchUserRepositoryInterface,
        posterImageRepository: PosterImageRepsitoryInterface
    ) {
        self.tokenStorage = tokenStorage
        self.searchUserRepository = searchUserRepository
        self.posterImageRepository = posterImageRepository
    }
    
    func searchInitialUsers(query: String) async throws -> [GithubUser] {
        guard let token = tokenStorage.retrieve() else {
            throw SearchUserUseCaseError.tokenNotFound
        }
        
        resetSearch()
        
        currentQuery = query
        
        let githubQuery = GithubUserQuery(q: query)
        
        let usersPage =  try await searchUserRepository.fetchGithubUsers(
            query: githubQuery,
            page: currentPage,
            perPage: perPage, token: token
        )
        
        hasNextPage = usersPage.hasNextPage
        totalPages = usersPage.totalPage
        
        return usersPage.users
    }
    
    func loadNextPage() async throws -> [GithubUser] {
        guard let token = tokenStorage.retrieve() else {
            throw SearchUserUseCaseError.tokenNotFound
        }
        
        guard let query = currentQuery else {
            throw SearchUserUseCaseError.queryMissing
        }
        
        guard hasNextPage else {
            throw SearchUserUseCaseError.noNextPage
        }
        
        let nextPage = currentPage + 1
        let githubQuery = GithubUserQuery(q: query)
        
        let usersPage = try await searchUserRepository.fetchGithubUsers(
            query: githubQuery,
            page: nextPage,
            perPage: perPage,
            token: token)
        
        hasNextPage = usersPage.hasNextPage
        currentPage = usersPage.currentPage
        totalPages = usersPage.totalPage
        
        return usersPage.users
    }
    
    func fetchUserImage(
        with imagePath: String,
        id: Int
    ) async throws -> Data {
        return try await posterImageRepository.fetchPoster(
            with: imagePath,
            userID: id
        )
    }
    
    func resetSearch() {
        currentQuery = nil
        hasNextPage = false
        currentPage = 1
        totalPages = 0
    }
}
