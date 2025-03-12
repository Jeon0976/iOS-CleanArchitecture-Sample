//
//  GithubAccessTokenRequest+DTO.swift
//  Data
//
//  Created by 전성훈 on 3/11/25.
//

struct GithubAccessTokenRequest: Encodable {
    let clientId: String
    let clientSecret: String
    let code: String
    
    enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case clientSecret = "client_secret"
        case code
    }
}
