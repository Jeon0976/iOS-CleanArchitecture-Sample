//
//  GithubAccessTokenResponse+DTO.swift
//  Data
//
//  Created by 전성훈 on 3/11/25.
//

import Foundation

import Domain

struct GithubAccessTokenResponse: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
    }
    
    func toDomain() -> GithubToken {
        return GithubToken(
            token: accessToken,
            tokenType: tokenType
        )
    }
}
