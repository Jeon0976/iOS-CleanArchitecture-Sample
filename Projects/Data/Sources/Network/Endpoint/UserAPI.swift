//
//  UserAPI.swift
//  Data
//
//  Created by 전성훈 on 3/13/25.
//

import Foundation

enum UserAPI {
    case getUser(token: String)
}

extension UserAPI: NetworkEndpoint {
    var baseURL: URL {
        GithubBaseURL.api
    }
    
    var path: String {
        switch self {
        case .getUser:
            return "user"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUser:
            return .get
        }
    }
    
    var task: NetworkTask {
        switch self {
        case .getUser:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getUser(let token):
            return [
                "Accept": "application/vnd.github.v3+json",
                "Authorization": "Bearer \(token)"
            ]
        }
    }
    
}
