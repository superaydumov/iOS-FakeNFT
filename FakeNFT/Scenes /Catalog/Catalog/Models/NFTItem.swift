//
//  NFTItem.swift
//  FakeNFT
//
//  Created by Ян Максимов on 05.01.2024.
//

import Foundation

struct NFTItem: Codable {
    let id: String
    let name: String
    let images: [String]
    let rating: Int
    let price: Double
}
