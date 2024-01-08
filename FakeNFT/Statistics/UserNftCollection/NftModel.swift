//
//  NFTModel.swift
//  FakeNFT
//
//  Created by Андрей Асланов on 27.12.23.
//

import Foundation

struct NftModel: Codable {
    var createdAt: String?
    var name: String?
    var images: [URL]?
    var rating: Int?
    var description: String?
    var price: Float?
    var author: URL?
    var id: String?

    init(createdAt: String? = nil, name: String? = nil, images: [URL]? = nil, rating: Int? = nil, description: String? = nil, price: Float? = nil, author: URL? = nil, id: String? = nil) {
        self.createdAt = createdAt
        self.name = name
        self.images = images
        self.rating = rating
        self.description = description
        self.price = price
        self.author = author
        self.id = id
    }
}
