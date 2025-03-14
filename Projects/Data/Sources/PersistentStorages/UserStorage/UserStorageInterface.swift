//
//  UserStorageInterface.swift
//  Data
//
//  Created by 전성훈 on 3/13/25.
//

import Foundation

import Domain

protocol UserStorageInterface {
    func saveUser(_ user: User)
    func loadUser() -> User?
    func clearUser()
}
