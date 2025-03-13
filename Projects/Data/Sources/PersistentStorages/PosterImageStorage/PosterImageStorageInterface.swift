//
//  PosterImageStorageInterface.swift
//  Data
//
//  Created by 전성훈 on 3/12/25.
//

import Foundation


/// 이미지 데이터의 저장 및 검색을 관리하는 프로토콜입니다.
///
/// - 특정 저장 용량과 함께 이미지 데이터를 저장하고 검색하는 메커니즘을 제공합니다.
/// - 구현체는 이 프로토콜을 사용하여 다양한 저장 방식(메모리, 캐시 등)을 통해 구체화할 수 있도록 설계했습니다.
/// - async/await 패턴을 사용하여 비동기 호출을 지원합니다.
public protocol PosterImageStorageInterface {
    var capacity: UInt { get }
    
    func getData(key: Int) async -> Data?
    func setData(key: Int, value: Data) async
}
