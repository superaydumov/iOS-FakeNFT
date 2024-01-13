//
//  UserDefaultsManager.swift
//  FakeNFT
//
//  Created by Андрей Асланов on 08.01.24.
//

import Foundation

protocol UserDefaultsManagerProtocol {
    func saveLikedNftIds(_ likedNftIds: [String])
    func loadLikedNftIds() -> [String]
    func saveCartItems(_ cartItemIds: [String])
    func loadCartItems() -> [String]
}

final class UserDefaultsManager: UserDefaultsManagerProtocol {

    // MARK: - Likes
    func saveLikedNftIds(_ likedNftIds: [String]) {
        let defaults = UserDefaults.standard
        defaults.set(likedNftIds, forKey: "LikedNftIdsKey")
        DispatchQueue.global().async {
            defaults.synchronize()
        }
    }

    func loadLikedNftIds() -> [String] {
        let defaults = UserDefaults.standard
        if let loadedLikedNftIds = defaults.stringArray(forKey: "LikedNftIdsKey") {
            return loadedLikedNftIds
        } else {
            return []
        }
    }

    // MARK: - Cart
    func saveCartItems(_ cartItemIds: [String]) {
        let defaults = UserDefaults.standard
        defaults.set(cartItemIds, forKey: "CartItemIdsKey")
        DispatchQueue.global().async {
            defaults.synchronize()
        }
    }

    func loadCartItems() -> [String] {
        let defaults = UserDefaults.standard
        if let loadedCartItemIds = defaults.stringArray(forKey: "CartItemIdsKey") {
            return loadedCartItemIds
        } else {
            return []
        }
    }
}
