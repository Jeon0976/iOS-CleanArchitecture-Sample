//
//  NetworkTask.swift
//  Data
//
//  Created by 전성훈 on 3/11/25.
//
import Foundation

public enum NetworkTask {
    case requestPlain
    case requestData(Data)
    case requestJSONEncodable(Encodable)
    case requestParameters(parameters: [String: Any], encoding: ParameterEncoding)
}
