//
//  UserRepositoryInterface.swift
//  Domain
//
//  Created by 전성훈 on 3/13/25.
//

import Foundation

public protocol UserRepositoryInterface {
    func getUser(token: String) async throws -> User
    func clearUser()
}
