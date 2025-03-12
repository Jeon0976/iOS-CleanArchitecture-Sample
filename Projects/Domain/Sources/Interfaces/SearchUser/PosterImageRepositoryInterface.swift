//
//  PosterImageRepositoryInterface.swift
//  Domain
//
//  Created by 전성훈 on 3/12/25.
//

import Foundation

public protocol PosterImageRepsitoryInterface {
    func featchPoster(
        with imagePath: String,
        userID: String
    ) async throws -> Data
}
