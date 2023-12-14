//
//  UserModel.swift
//  FakeNFT
//
//  Created by Андрей Асланов on 10.12.23.
//

import Foundation

struct UserModel: Decodable {
    var avatar: String?
    var username: String?
    var nftCount: String?
    var description: String?
    var website: String?
    var rating: String?

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
