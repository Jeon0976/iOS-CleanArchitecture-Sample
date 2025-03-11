//
//  GithubTokenRepositoryInterface.swift
//  Domain
//
//  Created by 전성훈 on 3/11/25.
//

import Foundation

public protocol GithubTokenRepositoryInterface {
    func requestCode() async throws -> URL
    func requestAccessToken(with code: String) async throws -> GithubToken
}
