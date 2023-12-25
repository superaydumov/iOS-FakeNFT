//
//  NFTCollectionInfo.swift
//  FakeNFT
//
//  Created by Ян Максимов on 22.12.2023.
//

import Foundation

struct NFTCollectionInfo {
    let name: String
    let cover: URL?
    let nfts: [String]
    let description: String
    let author: String
    let id: String
    
    init(fromNFTCollection collection: NFTCollection) {
        self.name = collection.name
        self.cover = collection.cover.convertedURL()
        self.nfts = collection.nfts
        self.description = collection.description
        self.author = collection.author
        self.id = collection.id
    }
}
