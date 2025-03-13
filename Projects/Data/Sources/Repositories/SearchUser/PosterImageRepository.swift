//
//  PosterImageRepository.swift
//  Data
//
//  Created by 전성훈 on 3/12/25.
//

import Foundation

import Domain

final class PosterImageRepository: PosterImageRepsitoryInterface {
    
    private let networkSession: NetworkSession
    private let cache: PosterImageStorageInterface
    
    init(
        networkSession: NetworkSession,
        cache: PosterImageStorageInterface
    ) {
        self.networkSession = networkSession
        self.cache = cache
    }
    
    func featchPoster(
        with imagePath: String,
        userID: Int
    ) async throws -> Data {

        if let cachedData = await cache.getData(key: userID) {
            print("캐시에서 이미지 로드됨: \(userID)")

            return cachedData
        }
        
        print("이미지 다운로드 시도: \(imagePath)")

        do {
            let data = try Data(contentsOf: URL(string: imagePath)!)
            
            print("이미지 다운로드 성공: \(data.count) 바이트")
            await cache.setData(key: userID, value: data)
            return data
        } catch {
            print("이미지 다운로드 실패: \(error.localizedDescription)")

            throw error
        }
    }
}
