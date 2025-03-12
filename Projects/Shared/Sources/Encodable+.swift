//
//  Encodable+.swift
//  Shared
//
//  Created by 전성훈 on 3/12/25.
//

import Foundation

extension Encodable {
    public func toDictionary() -> [String: Any] {
        do {
            let data = try JSONEncoder().encode(self)
            let dic = try JSONSerialization.jsonObject(
                with: data,
                options: [.fragmentsAllowed]
            ) as? [String: Any]
            
            return dic ?? [:]
        } catch {
            return [:]
        }
    }
}
