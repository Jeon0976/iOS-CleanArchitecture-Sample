//
//  PosterImageRepositoryInterface.swift
//  Domain
//
//  Created by 전성훈 on 3/12/25.
//

import Foundation

public protocol PosterImageRepsitoryInterface {
    func fetchPoster(
        with imagePath: String,
        userID: Int
    ) async throws -> Data
}
