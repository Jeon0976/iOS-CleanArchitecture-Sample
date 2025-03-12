//
//  NetworkEndpoint.swift
//  Data
//
//  Created by 전성훈 on 3/11/25.
//

import Foundation

public protocol NetworkEndpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var task: NetworkTask { get }
    var headers: [String: String]? { get }
    var sampleData: Data { get }
}

extension NetworkEndpoint {
    var sampleData: Data { Data() }
    
    func url() -> URL {
        return baseURL.appending(path: path)
    }
    
    func urlRequest() throws -> URLRequest {
        var request = URLRequest(url: url())
        request.httpMethod = method.rawValue
        
        if let headers = headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        switch task {
            
        case .requestPlain:
            break
        case .requestData(let data):
            request.httpBody = data
        case .requestJSONEncodable(let encodable):
            let encoder = JSONEncoder()
            
            request.httpBody = try encoder.encode(encodable)
            
            if request.value(forHTTPHeaderField: "Content-Type") == nil {
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        case .requestParameters(parameters: let parameters, encoding: let encoding):
            try encoding.encode(parameters: parameters, into: &request)
        }
        
        return request
    }
}
