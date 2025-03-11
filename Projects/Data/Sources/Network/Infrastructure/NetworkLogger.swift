//
//  NetworkError.swift
//  Data
//
//  Created by 전성훈 on 3/11/25.
//

import Foundation

import Shared

final class NetworkLogger {
    func willSend<E: NetworkEndpoint>(_ request: URLRequest, endpoint: E) {
        let url = request.url?.absoluteString ?? "unknown url"
        let method = request.httpMethod ?? "unknown method"
        
        /// HTTP Request Summary
        var httpLog = """
                       [HTTP Request]
                       URL: \(url)
                       TARGET: \(String(describing: endpoint))
                       METHOD: \(method)\n
                       """
        /// HTTP Request Header
        httpLog.append("HEADER: [\n")
        request.allHTTPHeaderFields?.forEach {
            httpLog.append("\t\($0): \($1)\n")
        }
        httpLog.append("]\n")
        
        /// HTTP Request Body
        if let body = request.httpBody,
           let bodyString = String(bytes: body, encoding: String.Encoding.utf8) {
            httpLog.append("BODY: \n\(bodyString)\n")
        }
        httpLog.append("[HTTP Request End]")
        
        printIfDebug(httpLog)
    }
    
    func didReceive<E: NetworkEndpoint>(
        data: Data,
        response: HTTPURLResponse,
        endpoint: E
    ) {
        let url = response.url?.absoluteString ?? "nil"
        let statusCode = response.statusCode
        
        /// HTTP Response Summary
        var httpLog = """
                       [HTTP Response]
                       TARGET: \(String(describing: endpoint))
                       URL: \(url)
                       STATUS CODE: \(statusCode)\n
                       """
        
        /// HTTP Response Header
        httpLog.append("HEADER: [\n")
        response.allHeaderFields.forEach {
            httpLog.append("\t\($0): \($1)\n")
        }
        httpLog.append("]\n")
        
        /// HTTP Response Data
        httpLog.append("RESPONSE DATA: \n")
        if let responseString = String(bytes: data, encoding: String.Encoding.utf8) {
            httpLog.append("\(responseString)\n")
        }
        httpLog.append("[HTTP Response End]")
        
        printIfDebug(httpLog)
    }
    
    func logStubRequest<E: NetworkEndpoint>(_ endpoint: E) {
        printIfDebug("[STUB] Using stub response for \(String(describing: endpoint))")
    }
}
