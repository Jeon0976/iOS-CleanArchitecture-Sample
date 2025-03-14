//
//  SearchUserAPI.swift
//  Data
//
//  Created by 전성훈 on 3/12/25.
//

import Foundation

import Shared

enum SearchUserAPI {
    case requestUsers(requset: SearchUserRequest, token: String)
    case downloadImage(url: String)
}

extension SearchUserAPI: NetworkEndpoint {
    var baseURL: URL {
        switch self {
        case .requestUsers:
            return GithubBaseURL.api
        case .downloadImage(let url):
            return URL(string: url)!
        }
    }
    
    var path: String {
        switch self {
        case .requestUsers:
            return "search/users"
        case .downloadImage:
            return ""
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .requestUsers:
            return .get
        case .downloadImage:
            return .get
        }
    }
    
    var task: NetworkTask {
        switch self {
        case .requestUsers(let requset, _):
            return .requestParameters(
                parameters: requset.toDictionary(),
                encoding: URLEncoding.queryString
            )
        case .downloadImage:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .requestUsers(_, let token):
            return [
                "Accept": "application/vnd.github.v3+json",
                "Authorization": "Bearer \(token)"
            ]
        case .downloadImage:
            return [:]
        }
    }
}
