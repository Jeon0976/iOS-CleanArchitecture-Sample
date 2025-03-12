//
//  GithubToken.swift
//  Domain
//
//  Created by 전성훈 on 3/11/25.
//

public struct GithubTokenClientInfo {
    let clientId: String
    let clientSecret: String
    let code: String
    
    public init(
        clientId: String,
        clientSecret: String,
        code: String
    ) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.code = code
    }
}

// TODO: Type enum으로 리팩토링
public struct GithubToken {
    let token: String
    let tokenType: String
    
    public init(
        token: String,
        tokenType: String
    ) {
        self.token = token
        self.tokenType = tokenType
    }
}
