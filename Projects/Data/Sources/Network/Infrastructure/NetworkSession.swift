//
//  NetworkSession.swift
//  Data
//
//  Created by 전성훈 on 3/11/25.
//

import Foundation

open class NetworkSession {
    private let session: URLSession
    private let isStub: Bool
    private let logger: NetworkLogger?
    
    public init(
        session: URLSession = .shared,
        isStub: Bool = false,
        logger: NetworkLogger? = NetworkLogger()
    ) {
        self.session = session
        self.isStub = isStub
        self.logger = logger
    }
    
    open func request<T: Decodable, E: NetworkEndpoint>(
        _ endpoint: E,
        type: T.Type
    ) async throws -> T {
        guard !isStub else {
            logger?.logStubRequest(endpoint)
            
            try await Task.sleep(nanoseconds: 100_000_000)
            
            do {
                return try JSONDecoder().decode(T.self, from: endpoint.sampleData)
            } catch {
                throw NetworkError.decodingError
            }
        }
        
        do {
            let request = try endpoint.urlRequest()
            
            logger?.willSend(
                request,
                endpoint: endpoint
            )
            
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            logger?.didReceive(
                data: data,
                response: httpResponse,
                endpoint: endpoint
            )
            
            if (200..<300).contains(httpResponse.statusCode) {
                do {
                    return try JSONDecoder().decode(
                        T.self,
                        from: data
                    )
                } catch {
                    throw NetworkError.decodingError
                }
            } else {
                throw NetworkError.mapHTTPStatus(httpResponse.statusCode)
            }
        } catch {
            if let networkError = error as? NetworkError {
                throw networkError
            }
            
            throw NetworkError.unknown
        }
    }
    
    open func requestWithNoContent<E: NetworkEndpoint>(
        _ endpoint: E
    ) async throws {
        guard !isStub else {
            logger?.logStubRequest(endpoint)
            
            try await Task.sleep(nanoseconds: 100_000_000)
            
            return
        }
        
        do {
            let request = try endpoint.urlRequest()
            
            logger?.willSend(
                request,
                endpoint: endpoint
            )
            
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            logger?.didReceive(
                data: data,
                response: httpResponse,
                endpoint: endpoint
            )
            
            if !(200..<300).contains(httpResponse.statusCode) {
                throw NetworkError.mapHTTPStatus(httpResponse.statusCode)
            }
        } catch {
            if let networkError = error as? NetworkError {
                throw networkError
            }
            throw NetworkError.unknown
        }
    }
    
    private func mapError(_ error: Error) -> NetworkError {
        let error = error as NSError
        
        switch error.code {
        case NSURLErrorBadURL:
            return .invalidURL
        case NSURLErrorTimedOut:
            return .requestTimeout
        case NSURLErrorCannotConnectToHost, NSURLErrorNetworkConnectionLost:
            return .badConnection
        default:
            return .unknown
        }
    }
}
