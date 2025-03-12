//
//  Node.swift
//  Data
//
//  Created by 전성훈 on 3/12/25.
//

import Foundation

final class Node<T> {
    var value: T
    var next: Node<T>?
    var prev: Node<T>?
    
    init(
        value: T,
        next: Node? = nil,
        prev: Node? = nil
    ) {
        self.value = value
        self.next = next
        self.prev = prev
    }
}
