//
//  NetworkProvider.swift
//  Data
//
//  Created by 전성훈 on 3/11/25.
//

import Foundation

protocol NetworkProvider {
    associatedtype Endpoint: NetworkEndpoint

    func request<T: Decodable>(_ target: Endpoint, tpye: T.Type) async throws -> T
    func requestWithNoContent(_ target: Endpoint) async throws
}
