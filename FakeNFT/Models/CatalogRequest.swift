//
//  CatalogRequest.swift
//  FakeNFT
//
//  Created by Ян Максимов on 22.12.2023.
//

import Foundation

struct CatalogRequest: NetworkRequest {
    var endpoint: URL?
    var httpMethod: HttpMethod
    var dto: Encodable?
    var headers: [String: String]?

    init(endpoint: URL? = nil,
         httpMethod: HttpMethod = .get,
         dto: Encodable? = nil,
         headers: [String: String]? = nil
    ) {
        self.endpoint = endpoint
        self.httpMethod = httpMethod
        self.dto = dto
        self.headers = headers
    }
}
