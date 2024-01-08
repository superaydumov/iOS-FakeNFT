//
//  UserModel.swift
//  FakeNFT
//
//  Created by Андрей Асланов on 10.12.23.
//

import Foundation

struct UserModel: Decodable {
    let avatar: String?
    let username: String?
    let nfts: [Nft]?
    let nftCount: String?
    let description: String?
    let website: String?
    let rating: String?
    let id: String?
    
    private enum CodingKeys: String, CodingKey {
        case avatar
        case username
        case nfts
        case nftCount
        case description
        case website
        case rating
        case id
    }
    
    init(avatar: String?, username: String?, nfts: [Nft]?, nftCount: String?, description: String?, website: String?, rating: String?, id: String?) {
        self.avatar = avatar
        self.username = username
        self.nfts = nfts
        self.nftCount = nftCount
        self.description = description
        self.website = website
        self.rating = rating
        self.id = id
    }
}
