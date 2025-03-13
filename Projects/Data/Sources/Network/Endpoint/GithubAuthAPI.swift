//
//  GithubAuthAPI.swift
//  Data
//
//  Created by 전성훈 on 3/11/25.
//

import Foundation

enum GithubAuthAPI {
    case requestAccessToken(request: GithubAccessTokenRequest)
}

extension GithubAuthAPI: NetworkEndpoint {
    var baseURL: URL {
        return GithubBaseURL.auth
    }
    
    var path: String {
        switch self {
        case .requestAccessToken:
            return "login/oauth/access_token"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .requestAccessToken:
            return .post
        }
    }
    
    var task: NetworkTask {
        switch self {
        case .requestAccessToken(let request):
            return .requestJSONEncodable(request)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .requestAccessToken:
            return [
                "Accept": "application/json",
                "Content-Type": "application/json"
            ]
        }
    }
    
    var sampleData: Data {
        switch self {
        case .requestAccessToken:

            let sampleResponse =
            """
            {
                "access_token": "sample_token",
                "token_type": "bearer",
                "scope": "repo,gist"
            }
            """
            return Data(sampleResponse.utf8)
        }
    }
}

