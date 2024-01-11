//
//  CartModel.swift
//  FakeNFT
//
//  Created by Ян Максимов on 07.01.2024.
//

import Foundation

struct CartModel {
    let id: String
    let nfts: [String]

    init(cartResult: CartResult) {
        self.id = cartResult.id
        self.nfts = cartResult.nfts
    }
}
