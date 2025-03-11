//
//  URLEncoding.swift
//  Data
//
//  Created by 전성훈 on 3/11/25.
//

import Foundation

struct URLEncoding: ParameterEncoding {
    enum Destination {
        case queryString
        case httpBody
    }
    
    let destination: Destination
    
    init(_ destination: Destination = .queryString) {
        self.destination = destination
    }
    
    static let queryString = URLEncoding(.queryString)
    static let httpBody = URLEncoding(.httpBody)
    
    func encode(parameters: [String: Any], into request: inout URLRequest) throws {
        guard let url = request.url else { throw NetworkError.invalidURL }
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            let percentEncodedQuery = urlComponents.percentEncodedQuery.map { $0 + "&" } ?? ""
            let queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: "\(value)")
            }
            urlComponents.percentEncodedQuery = percentEncodedQuery + queryItems.map { item in
                let escapedValue = item.value?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                return "\(item.name)=\(escapedValue)"
            }.joined(separator: "&")
            request.url = urlComponents.url
        }
    }
}

