//
//  MockNetworkSession.swift
//  Data
//
//  Created by 전성훈 on 3/11/25.
//

import Data

final class MockNetworkSession: NetworkSession {
    var requestCalled = false
    var testEndPoint: NetworkEndpoint?
    var response: Any?
    var error: Error?
    
    init(
        requestCalled: Bool = false,
        testEndPoint: NetworkEndpoint? = nil,
        response: Any? = nil,
        error: Error? = nil
    ) {
        self.requestCalled = requestCalled
        self.testEndPoint = testEndPoint
        self.response = response
        self.error = error
        
        super.init()
    }
    
    override func request<T, E>(_ endpoint: E, type: T.Type) async throws -> T where T: Decodable, E: NetworkEndpoint {
        requestCalled = true
        testEndPoint = endpoint
        
        if let error = error { throw error }
        
        if let response = response as? T {
            return response
        }
        
        throw NetworkError.unknown
    }
}
