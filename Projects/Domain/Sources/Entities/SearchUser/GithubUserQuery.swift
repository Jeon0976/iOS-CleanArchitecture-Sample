//
//  GithubUserQuery.swift
//  Domain
//
//  Created by 전성훈 on 3/12/25.
//

import Foundation

public struct GithubUserQuery {
    public let q: String
    
    public init(q: String) {
        self.q = q
    }
}
