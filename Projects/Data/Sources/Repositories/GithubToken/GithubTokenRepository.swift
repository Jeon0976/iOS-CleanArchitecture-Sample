//
//  GithubTokenRepository.swift
//  Data
//
//  Created by 전성훈 on 3/11/25.
//

import Foundation

import Domain

enum DataError: Error {
    case plistNotFound
    case invalidAPIPlistData
    case unableResolveURL
}

final class GithubTokenRepository: GithubTokenRepositoryInterface {
    
    private let networkSession: NetworkSession
    
    init(networkSession: NetworkSession) {
        self.networkSession = networkSession
    }
    
    func requestCode() async throws -> URL {
        guard let clientID = loadAPIPlistDictionary()?.clientID else {
            throw DataError.invalidAPIPlistData
        }
        
        let scope = "user"
        
        // GitHub OAuth 인증 URL 생성
        let urlString = "https://github.com/login/oauth/authorize?client_id=\(clientID)&scope=\(scope)"
        
        guard let url = URL(string: urlString) else {
            throw DataError.unableResolveURL
        }
        
        return url
    }
    
    func requestAccessToken(with code: String) async throws -> GithubToken {
        guard let clientInfo = loadAPIPlistDictionary() else {
            throw DataError.invalidAPIPlistData
        }
        
        let request = GithubAccessTokenRequest(
            clientId: clientInfo.clientID,
            clientSecret: clientInfo.clientSecret,
            code: code
        )
        
        return try await networkSession.request(
            GithubAuthAPI.requestAccessToken(request: request),
            type: GithubAccessTokenResponse.self
        ).toDomain()
    }
    
    private func loadAPIPlistDictionary() -> (clientID: String, clientSecret: String)? {
        guard let infoDict = Bundle(for: type(of: self)).infoDictionary,
              let clientId = infoDict["Github_Client_Id"] as? String,
              let clientSecrets = infoDict["Github_Client_secrets"] as? String
        else {
            return nil
        }
        
        return (clientId, clientSecrets)
    }
}
