//
//  Untitled.swift
//  Shared
//
//  Created by 전성훈 on 3/11/25.
//

public func printIfDebug(_ message: String) {
    #if DEBUG
    print(message)
    #endif
}
