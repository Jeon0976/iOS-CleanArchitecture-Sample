//
//  TokenStorages.swift
//  Core
//
//  Created by 전성훈 on 3/11/25.
//

public protocol TokenStorage {
    func store(token: String)
    func retrieve() -> String?
    func clear()
}
