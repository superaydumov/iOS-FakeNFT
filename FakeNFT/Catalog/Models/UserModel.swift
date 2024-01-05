//
//  UserModel.swift
//  FakeNFT
//
//  Created by Ян Максимов on 27.12.2023.
//

import Foundation

struct UserModel {
    let id: String
    let name: String
    let website: URL?
    
    init(userResult: UserResult) {
        self.id = userResult.id
        self.name = userResult.name
        if let websiteString = userResult.website, !websiteString.isEmpty {
            self.website = URL(string: websiteString)
        } else {
            self.website = nil
        }
    }
}
