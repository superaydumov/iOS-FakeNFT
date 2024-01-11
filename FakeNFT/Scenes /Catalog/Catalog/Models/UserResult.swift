//
//  UserResult.swift
//  FakeNFT
//
//  Created by Ян Максимов on 27.12.2023.
//

import Foundation

struct UserResult: Codable {
    let id: String
    let name: String
    let website: String?
    let avatar: String?
    let description: String?
    let nfts: [String?]
    let rating: String?
}
