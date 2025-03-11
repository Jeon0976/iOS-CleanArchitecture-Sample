//
//  GithubToken.swift
//  Domain
//
//  Created by 전성훈 on 3/11/25.
//

public struct GithubTokenClientInfo {
    public let clientId: String
    public let clientSecret: String
    public let code: String
}

// TODO: Type enum으로 리팩토링
public struct GithubToken {
    public let token: String
    public let tokenType: String
    
    public init(
        token: String,
        tokenType: String
    ) {
        self.token = token
        self.tokenType = tokenType
    }
}
