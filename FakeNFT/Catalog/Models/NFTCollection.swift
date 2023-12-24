//
//  CatalogModel.swift
//  FakeNFT
//
//  Created by Ян Максимов on 11.12.2023.
//

import Foundation

struct NFTCollection: Codable {
    let name: String
    let cover: String
    let nfts: [String]
    let description: String
    let author: String
    let id: String
}
