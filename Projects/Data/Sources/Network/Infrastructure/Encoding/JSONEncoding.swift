//
//  JSONEncoding.swift
//  Data
//
//  Created by 전성훈 on 3/11/25.
//

import Foundation

struct JSONEncoding: ParameterEncoding {
    static let `default` = JSONEncoding()
    
    func encode(parameters: [String: Any], into request: inout URLRequest) throws {
        do {
            let data = try JSONSerialization.data(withJSONObject: parameters)
            
            if request.value(forHTTPHeaderField: "Content-Type") == nil {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
            request.httpBody = data
        } catch {
            throw NetworkError.invalidParameters
        }
    }
}
