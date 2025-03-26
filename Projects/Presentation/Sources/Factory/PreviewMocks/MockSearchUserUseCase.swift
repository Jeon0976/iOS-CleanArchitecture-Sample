//
//  MockSearchUserUseCase.swift
//  Presentation
//
//  Created by 전성훈 on 3/26/25.
//

import UIKit

import Domain

final class MockSearchUserUseCase: SearchUserUseCaseInterface {
    var currentQuery: String? = "swift"
    var hasNextPage: Bool = true
    var currentPage: Int = 1
    var totalPages: Int = 5
    var perPage: Int = 30
    
    var shouldThrowError = false
    var errorType: SearchUserUseCaseError = .tokenNotFound
    
    // 미리보기용 더미 사용자 데이터 생성
    private func generateMockUsers() -> [GithubUser] {
        return [
            GithubUser(id: 1, name: "apple", posterPath: "https://avatars.githubusercontent.com/u/10639145", url: URL(string:"https://github.com/apple")!),
            GithubUser(id: 2, name: "microsoft", posterPath: "https://avatars.githubusercontent.com/u/6154722", url: URL(string:"https://github.com/microsoft")!),
            GithubUser(id: 3, name: "google", posterPath: "https://avatars.githubusercontent.com/u/1342004", url: URL(string:"https://github.com/google")!),
            GithubUser(id: 4, name: "facebook", posterPath: "https://avatars.githubusercontent.com/u/69631", url: URL(string:"https://github.com/facebook")!),
            GithubUser(id: 5, name: "aws", posterPath: "https://avatars.githubusercontent.com/u/2232217", url: URL(string:"https://github.com/aws")!)
        ]
    }
    
    func searchInitialUsers(query: String) async throws -> [GithubUser] {
        if shouldThrowError {
            throw errorType
        }
        
        currentQuery = query
        currentPage = 1
        return generateMockUsers()
    }
    
    func loadNextPage() async throws -> [GithubUser] {
        if shouldThrowError {
            throw errorType
        }
        
        if !hasNextPage {
            throw SearchUserUseCaseError.noNextPage
        }
        
        currentPage += 1
        
        if currentPage >= totalPages {
            hasNextPage = false
        }
        
        // 미리보기에서는 다음 페이지도 같은 사용자 데이터 반환
        return generateMockUsers()
    }
    
    func fetchUserImage(with imagePath: String, id: Int) async throws -> Data {
        if shouldThrowError {
            throw NSError(domain: "MockError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Image not found"])
        }
        
        // 미리보기용 더미 이미지 데이터 생성
        let size = 100
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
        let mockImage = renderer.image { context in
            UIColor.systemBlue.setFill()
            context.fill(CGRect(x: 0, y: 0, width: size, height: size))
            
            // 사용자 ID를 이미지에 표시
            let text = "\(id)"
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 30),
                .foregroundColor: UIColor.white
            ]
            
            let textSize = text.size(withAttributes: attributes)
            let rect = CGRect(x: (CGFloat(size) - textSize.width) / 2, y: (CGFloat(size) - textSize.height) / 2, width: textSize.width, height: textSize.height)
            text.draw(in: rect, withAttributes: attributes)
        }
        
        return mockImage.pngData() ?? Data()
    }
    
    func resetSearch() {
        currentQuery = nil
        hasNextPage = true
        currentPage = 1
        totalPages = 5
    }
}
