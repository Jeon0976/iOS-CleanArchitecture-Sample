//
//  MockPosterStorage.swift
//  Data
//
//  Created by 전성훈 on 3/12/25.
//

import Foundation

import Data

final class MockPosterStorage: PosterImageStorageInterface {
    
    var calledGetData = false
    var calledSetData = false
    
    private struct CacheValue {
        let key: String
        var value: Data
    }
    
    private(set) var capacity: UInt
    private var list: [CacheValue] = []
    
    init(capacity: UInt) {
        self.capacity = capacity
    }
    
    func getData(key: String) async -> Data? {
        guard let value = list.first(where: { $0.key == key }) else { return nil
        }
        
        calledGetData = true
        
        return value.value
    }
    
    func setData(key: String, value: Data) async {
        calledSetData = true
        
        if let index = list.firstIndex(where: { $0.key == key }) {
            list[index].value = value
        } else {
            if list.count == capacity {
                list.removeLast()
            }
            
            let newValue = CacheValue(key: key, value: value)
            
            list.insert(newValue, at: 0)
        }
    }
}
