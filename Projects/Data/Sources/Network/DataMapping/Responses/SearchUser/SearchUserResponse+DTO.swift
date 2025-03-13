//
//  SearchUserResponse.swift
//  Data
//
//  Created by 전성훈 on 3/12/25.
//

import Foundation

import Domain

struct SearchUsersResponse: Decodable {
    let totalCount: Int
    let users: [SearchUserResponse]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case users = "items"
    }
    
    func toDomain(currentPage: Int) -> GithubUsersPage {
        let domainUsers = users.map { $0.toDomain() }
        
        return GithubUsersPage(
            totalCount: totalCount,
            currentPage: currentPage,
            users: domainUsers
        )
    }
}


struct SearchUserResponse: Decodable {
    let id: Int
    let name: String
    let url: String
    let imagePath: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "login"
        case url = "html_url"
        case imagePath = "avatar_url"
    }
    
    func toDomain() -> GithubUser {
        let url = URL(string: url) ?? URL(string: "https://github.com")!
        
        return GithubUser(
            id: id,
            name: name,
            posterPath: imagePath,
            url: url
        )
    }
}
