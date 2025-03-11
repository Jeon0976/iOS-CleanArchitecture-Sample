//
//  Encoding.swift
//  Data
//
//  Created by 전성훈 on 3/11/25.
//
import Foundation

public protocol ParameterEncoding {
    func encode(parameters: [String: Any], into request: inout URLRequest) throws
}
