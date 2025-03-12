//
//  NetworkError.swift
//  Data
//
//  Created by 전성훈 on 3/11/25.
//

public enum NetworkError: Error {
    case invalidURL
    case badConnection
    case invalidResponse
    case requestFailed
    case requestTimeout
    case noData
    case decodingError
    case apiRateLimitExceeded
    case tokenExceeded
    case invalidParameters
    case unknown
    
    var description: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .badConnection:
            return "Bad Connection"
        case .invalidResponse:
            return "Invalid Response"
        case .requestFailed:
            return "Network request failed"
        case .requestTimeout:
            return "Request timed out."
        case .noData:
            return "No data received"
        case .decodingError:
            return "Error decoding data"
        case .apiRateLimitExceeded:
            return "API Rate Limit Exceeded"
        case .tokenExceeded:
            return "Token exceeded"
        case .invalidParameters:
            return "Invalid Parameters"
        case .unknown:
            return "Unknown Error"
        }
    }
    
    static func mapHTTPStatus(_ statusCode: Int) -> NetworkError {
        switch statusCode {
        case 400:
            return .requestFailed
        case 401:
            return .tokenExceeded
        case 403:
            return .apiRateLimitExceeded
        case 404:
            return .invalidURL
        case 408:
            return .requestTimeout
        case 500...599:
            return .invalidResponse
        default:
            return .unknown
        }
    }
}
