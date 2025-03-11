//
//  NetworkSession.swift
//  Data
//
//  Created by 전성훈 on 3/11/25.
//

import Foundation

final class NetworkSession {
    private let session: URLSession
    private let isStub: Bool
    private let logger: NetworkLogger?
    
    
    init(
        session: URLSession = .shared,
        isStub: Bool = false,
        logger: NetworkLogger? = NetworkLogger()
    ) {
        self.session = session
        self.isStub = isStub
        self.logger = logger
    }
    
    func request<T: Decodable, E: NetworkEndpoint>(
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
    
    func requestWithNoContent<E: NetworkEndpoint>(
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
    
    func request<T: Decodable, E: NetworkEndpoint>(
        _ endpoint: E,
        type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> Cancellable {
        if isStub {
            logger?.logStubRequest(endpoint)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: endpoint.sampleData)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(NetworkError.decodingError))
                }
            }
            
            let task = URLSession.shared.dataTask(with: URL(string: "https://example.com")!)
            return NetworkCancellable(task: task)
        }
        
        do {
            let request = try endpoint.urlRequest()
            logger?.willSend(request, endpoint: endpoint)
            
            let task = session.dataTask(with: request) { [weak self] data, response, error in
                guard let self = self else { return }
                
                if let error = error {
                    completion(.failure(self.mapError(error)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NetworkError.noData))
                    return
                }
                
                self.logger?.didReceive(data: data, response: httpResponse, endpoint: endpoint)
                
                if (200..<300).contains(httpResponse.statusCode) {
                    do {
                        let decodedData = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(decodedData))
                    } catch {
                        completion(.failure(NetworkError.decodingError))
                    }
                } else {
                    completion(.failure(NetworkError.mapHTTPStatus(httpResponse.statusCode)))
                }
            }
            
            task.resume()
            return NetworkCancellable(task: task)
        } catch {
            completion(.failure(error))
            
            let task = URLSession.shared.dataTask(with: URL(string: "https://example.com")!)
            return NetworkCancellable(task: task)
        }
    }
    
    func requestWithNoContent<E: NetworkEndpoint>(
        _ endpoint: E,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable {
        if isStub {
            logger?.logStubRequest(endpoint)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                completion(.success(()))
            }
            
            // 더미 태스크 반환
            let task = URLSession.shared.dataTask(with: URL(string: "https://example.com")!)
            return NetworkCancellable(task: task)
        }
        
        do {
            let request = try endpoint.urlRequest()
            logger?.willSend(request, endpoint: endpoint)
            
            let task = session.dataTask(with: request) { [weak self] data, response, error in
                guard let self = self else { return }
                
                if let error = error {
                    completion(.failure(self.mapError(error)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }
                
                self.logger?.didReceive(data: data ?? Data(), response: httpResponse, endpoint: endpoint)
                
                if (200..<300).contains(httpResponse.statusCode) {
                    completion(.success(()))
                } else {
                    completion(.failure(NetworkError.mapHTTPStatus(httpResponse.statusCode)))
                }
            }
            
            task.resume()
            return NetworkCancellable(task: task)
        } catch {
            completion(.failure(error))
            
            // 더미 태스크 반환
            let task = URLSession.shared.dataTask(with: URL(string: "https://example.com")!)
            return NetworkCancellable(task: task)
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
