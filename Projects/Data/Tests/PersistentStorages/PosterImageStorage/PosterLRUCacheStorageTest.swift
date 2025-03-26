//
//  PosterLRUCacheStorageTest.swift
//  Data
//
//  Created by 전성훈 on 3/26/25.
//

import XCTest

@testable import Data

final class PosterLRUCacheStorageTest: XCTestCase {
    private var sut: PosterLRUCacheStorage!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = PosterLRUCacheStorage(capacity: 2)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        
        try super.tearDownWithError()
    }
    
    func test_storeData() async throws {
        // given
        let key = 1
        let value = "value".data(using: .utf8)!
        
        // when
        await sut.setData(key: key, value: value)
        let resultData = await sut.getData(key: key)
        
        // then
        XCTAssertEqual(resultData, value)
    }
    
    func test_storeDataWhenExceedingMaxCapacity() async throws {
        // given
        let key1 = 1
        let key2 = 2
        let key3 = 3
        
        let value1 = "value1".data(using: .utf8)!
        let value2 = "value2".data(using: .utf8)!
        let value3 = "value3".data(using: .utf8)!
        
        // when
        await sut.setData(key: key1, value: value1)
        await sut.setData(key: key2, value: value2)
        await sut.setData(key: key3, value: value3)
        
        let resultValue1 = await sut.getData(key: key1)
        let resultValue2 = await sut.getData(key: key2)
        let resultValue3 = await sut.getData(key: key3)
        
        // then
        XCTAssertNil(resultValue1)
        XCTAssertEqual(resultValue2, value2)
        XCTAssertEqual(resultValue3, value3)
    }
    
    
}
