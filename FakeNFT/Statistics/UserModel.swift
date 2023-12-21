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
    let nftCount: String?
    let description: String?
    let website: String?
    let rating: String?
    
    private enum CodingKeys: String, CodingKey {
        case avatar
        case username
        case nftCount
        case description
        case website
        case rating
    }
    
    init(avatar: String?, username: String?, nftCount: String?, description: String?, website: String?, rating: String?) {
        self.avatar = avatar
        self.username = username
        self.nftCount = nftCount
        self.description = description
        self.website = website
        self.rating = rating
    }
}
