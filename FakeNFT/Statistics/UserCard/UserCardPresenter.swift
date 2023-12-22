//
//  UserCardPresenter.swift
//  FakeNFT
//
//  Created by Андрей Асланов on 22.12.23.
//

protocol UserCardPresenterProtocol {
    func updateUI()
    func website() -> String
    func nftCount() -> String
}

import Foundation

final class UserCardPresenter: UserCardPresenterProtocol {
    
    private weak var view: UserCardView?
    private let user: UserModel
    
    init(user: UserModel, view: UserCardView) {
        self.user = user
        self.view = view
        self.updateUI()
    }
    
    func updateUI() {
        view?.updateUI(
            avatarURL: avatarURL(),
            username: username(),
            description: description()
        )
    }
    
    func nftCount() -> String {
        return user.nftCount ?? ""
    }
    
    func avatarURL() -> String {
        return user.avatar ?? ""
    }
    
    func username() -> String {
        return user.username ?? ""
    }
    
    func description() -> String {
        return user.description ?? ""
    }
    
    func website() -> String {
        return user.website ?? ""
    }
}
