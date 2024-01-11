//
//  NFTInformation.swift
//  FakeNFT
//
//  Created by Ян Максимов on 05.01.2024.
//

import Foundation

struct NFTInformation {
    let id: String
    let name: String
    let image: URL?
    let rating: Int
    let price: Double

    init(nft: NFTItem) {
        self.id = nft.id
        self.name = nft.name
        self.image = nft.images.first?.convertedURL()
        self.rating = nft.rating
        self.price = nft.price
    }
}
