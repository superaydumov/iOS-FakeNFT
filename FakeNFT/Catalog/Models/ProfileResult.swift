//
//  ProfileResult.swift
//  FakeNFT
//
//  Created by Ян Максимов on 27.12.2023.
//

import Foundation

struct ProfileResult: Codable {
    let id: String
    let likes: [String]
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String?]
}
