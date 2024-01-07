//
//  ProfileModel.swift
//  FakeNFT
//
//  Created by Ян Максимов on 27.12.2023.
//

import Foundation

struct ProfileModel {
    let id: String
    let likes: [String]
    
    init(profileResult: ProfileResult) {
        self.id = profileResult.id
        self.likes = profileResult.likes
    }
}
