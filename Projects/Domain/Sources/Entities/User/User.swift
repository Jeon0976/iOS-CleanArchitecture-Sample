//
//  User.swift
//  Domain
//
//  Created by 전성훈 on 3/13/25.
//

import Foundation

public struct User {
    let id: String
    let poster: Data
    let location: String
    let followers: Int
    let following: Int
    
    public init(
        id: String,
        poster: Data,
        location: String,
        followers: Int,
        following: Int
    ) {
        self.id = id
        self.poster = poster
        self.location = location
        self.followers = followers
        self.following = following
    }
}
