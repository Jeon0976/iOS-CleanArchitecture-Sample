//
//  MockPosterImageRepository.swift
//  Domain
//
//  Created by 전성훈 on 3/26/25.
//

import Foundation

import Domain

final class MockPosterImageRepository: PosterImageRepsitoryInterface {
    var imageData: Data?
    var error: Error?
    
    func fetchPoster(
        with imagePath: String,
        userID: Int
    ) async throws -> Data {
        
        if let error = error {
            throw error
        }
        
        return imageData ?? Data()
    }
}
