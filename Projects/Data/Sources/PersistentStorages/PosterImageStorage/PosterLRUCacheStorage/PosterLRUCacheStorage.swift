//
//  PosterLRUCacheStorage.swift
//  Data
//
//  Created by 전성훈 on 3/12/25.
//

import Foundation

actor PosterLRUCacheStorage: PosterImageStorageInterface {
    private struct CacheNode {
        let key: Int
        var value: Data
    }
        
    let capacity: UInt
    private var dict = [Int: Node<CacheNode>]()
    private var list = DoublyLinkedList<CacheNode>()
    
    init(capacity: UInt = 330) {
        self.capacity = capacity
    }
    
    func getData(key: Int) async -> Data? {
        guard let node = dict[key] else { return nil }
        
        list.moveToHead(node: node)
        
        return node.value.value
    }
    
    func setData(key: Int, value: Data) async {
        if let node = dict[key] {
            list.moveToHead(node: node)
            
            node.value.value = value
        } else {
            if list.count == capacity {
                if let node = list.removeLast() {
                    dict.removeValue(forKey: node.value.key)
                }
            }
            
            let newNode = list.push(value: CacheNode(key: key, value: value))
            
            dict[key] = newNode
        }
    }
}
