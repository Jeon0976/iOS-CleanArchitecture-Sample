//
//  GithubTokenRepositoryInterface.swift
//  Domain
//
//  Created by 전성훈 on 3/11/25.
//

public protocol GithubTokenRepositoryInterface {
    func requestAccessToken(request: GithubTokenClientInfo) async throws -> GithubToken
}
