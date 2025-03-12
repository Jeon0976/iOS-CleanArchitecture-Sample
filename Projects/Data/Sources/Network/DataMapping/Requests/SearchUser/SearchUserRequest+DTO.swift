//
//  SearchUserRequest.swift
//  Data
//
//  Created by 전성훈 on 3/12/25.
//

import Foundation

struct SearchUserRequest: Encodable {
    let query: String
    let page: Int
    let perPage: Int
    
    enum CodingKeys: String, CodingKey {
        case query = "q"
        case page
        case perPage = "per_page"
    }
}
