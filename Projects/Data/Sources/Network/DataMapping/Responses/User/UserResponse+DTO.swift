//
//  UserResponse+DTO.swift
//  Data
//
//  Created by 전성훈 on 3/13/25.
//

import Foundation

import Domain

struct UserResponse: Decodable {
    let id: String
    let name: String
    let imagePath: String
    let url: String
    let location: String
    let followers: Int
    let following: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "login"
        case imagePath = "avater_url"
        case url = "html_url"
        case location
        case followers
        case following
    }
    
    func toDomain() throws -> User {
        let imageData = try Data(contentsOf: URL(string: imagePath)!)
        
        return User(
            id: id,
            poster: imageData,
            location: location,
            followers: followers,
            following: following
        )
    }
}
