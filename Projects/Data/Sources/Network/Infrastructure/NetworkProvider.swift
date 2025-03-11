//
//  NetworkProvider.swift
//  Data
//
//  Created by 전성훈 on 3/11/25.
//

protocol NetworkProvider {
    associatedtype Endpoint: NetworkEndpoint
    
    func request<T: Decodable>(_ target: Endpoint, tpye: T.Type) async throws -> T
    
    func requestWithNoContent(_ target: Endpoint) async throws
    
    func request<T: Decodable>(_ target: Endpoint, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable
    
    func requestWithNoContent(
        _ target: Endpoint,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable
}
