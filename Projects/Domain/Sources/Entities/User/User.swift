//
//  User.swift
//  Domain
//
//  Created by 전성훈 on 3/13/25.
//

import Foundation

public struct User {
    let id: Int
    public let name: String
    public let poster: Data
    public let location: String
    public let followers: Int
    public let following: Int
    
    public init(
        id: Int,
        name: String,
        poster: Data,
        location: String,
        followers: Int,
        following: Int
    ) {
        self.id = id
        self.name = name
        self.poster = poster
        self.location = location
        self.followers = followers
        self.following = following
    }
}
