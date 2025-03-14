//
//  UserResponse+DTO.swift
//  Data
//
//  Created by 전성훈 on 3/13/25.
//

import Foundation

import Domain

struct UserResponse: Decodable {
    let id: Int
    let name: String
    let imagePath: String
    let url: String
    let location: String
    let followers: Int
    let following: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "login"
        case imagePath = "avatar_url"
        case url = "html_url"
        case location
        case followers
        case following
    }
    
    func toDomain() async throws -> User {
        print("GOGOGO")
        
        let (data, _) = try await URLSession.shared.data(from: URL(string: imagePath)!)
        
        print("GOGO")
        
        return User(
            id: id,
            name: name,
            poster: data,
            location: location,
            followers: followers,
            following: following
        )
    }
}
