//
//  UserCardPresenter.swift
//  FakeNFT
//
//  Created by Андрей Асланов on 22.12.23.
//

protocol UserCardViewOutput {
    func updateUI()
    func getUserInfo() -> UserModel
}

import Foundation

final class UserCardPresenter: UserCardViewOutput {
    
    private weak var view: UserCardViewInput?
    private let user: UserModel
    
    init(user: UserModel, view: UserCardViewInput) {
        self.user = user
        self.view = view
        self.updateUI()
    }
    
    func updateUI() {
        view?.updateUI(
            avatarURL: getUserInfo().avatar ?? "",
            username: getUserInfo().username ?? "",
            description: getUserInfo().description ?? ""
        )
    }
    
    func getUserInfo() -> UserModel {
        return user
    }
}
