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
        userID: String
    ) async throws -> Data {
        if let cachedData = await cache.getData(key: userID) {
            return cachedData
        }
        
        do {
            let data = try await networkSession.request(
                SearchUserAPI.downloadImage(url: imagePath),
                type: Data.self
            )
            
            await cache.setData(key: userID, value: data)
            
            return data
        } catch {
            throw error
        }
    }
}
