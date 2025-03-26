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
        let key: Int
        var value: Data
    }
    
    private(set) var capacity: UInt
    private var list: [CacheValue] = []
    
    init(capacity: UInt) {
        self.capacity = capacity
    }
    
    func getData(key: Int) async -> Data? {
        calledGetData = true

        guard let value = list.first(where: { $0.key == key }) else { return nil
        }
        
        return value.value
    }
    
    func setData(key: Int, value: Data) async {
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
