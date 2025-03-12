//
//  PosterLRUCacheStorage.swift
//  Data
//
//  Created by 전성훈 on 3/12/25.
//

import Foundation

actor LRUCacheStorage: PosterImageStorageInterface {
    private struct CacheNode {
        let key: String
        var value: Data
    }
        
    let capacity: UInt
    private var dict = [String: Node<CacheNode>]()
    private var list = DoublyLinkedList<CacheNode>()
    
    init(capacity: UInt = 330) {
        self.capacity = capacity
    }
    
    func getData(key: String) async -> Data? {
        guard let node = dict[key] else { return nil }
        
        list.moveToHead(node: node)
        
        return node.value.value
    }
    
    func setData(key: String, value: Data) async {
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
