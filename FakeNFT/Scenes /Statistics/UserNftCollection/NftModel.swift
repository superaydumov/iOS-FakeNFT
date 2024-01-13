//
//  NFTModel.swift
//  FakeNFT
//
//  Created by Андрей Асланов on 27.12.23.
//

import Foundation

struct NftModel: Codable {
    let createdAt: String?
    let name: String?
    let images: [URL]?
    let rating: Int?
    let description: String?
    let price: Float?
    let author: URL?
    let id: String?

    init(
        createdAt: String? = nil,
        name: String? = nil,
        images: [URL]? = nil,
        rating: Int? = nil,
        description: String? = nil,
        price: Float? = nil,
        author: URL? = nil,
        id: String? = nil
    ) {
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
