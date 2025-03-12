//
//  GithubUser.swift
//  Domain
//
//  Created by 전성훈 on 3/12/25.
//

import Foundation

public struct GithubUsersPage: Equatable {
    public let totalPage: Int
    public let currentPage: Int
    public let users: [GithubUser]
    
    private let defaultPerPage = 30
    
    var hasNextPage: Bool {
        return totalPage > currentPage
    }
    
    public init(
        totalCount: Int,
        currentPage: Int,
        users: [GithubUser]
    ) {
        self.totalPage = Int(ceil(Double(totalCount) / Double(defaultPerPage)))
        self.currentPage = currentPage
        self.users = users
    }
}

public struct GithubUser: Equatable {
    public let id: String
    public let name: String
    public let posterPath: String
    public let url: URL
    
    public init(
        id: String,
        name: String,
        posterPath: String,
        url: URL
    ) {
        self.id = id
        self.name = name
        self.posterPath = posterPath
        self.url = url
    }
}
