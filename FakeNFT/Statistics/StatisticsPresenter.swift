//
//  StatisticsPresenter.swift
//  FakeNFT
//
//  Created by Андрей Асланов on 10.12.23.
//

import Foundation

protocol StatisticsViewInPut: AnyObject {
    func updateUsers(users: [UserModel])
    func showActivityIndicator()
    func hideActivityIndicator()
}

final class StatisticsPresenter: StatisticsViewOutput {
    private weak var view: StatisticsViewInPut?
    private var users: [UserModel] = []
    private var networkClient: StatisticsNetworkClientProtocol
    
    init(view: StatisticsViewInPut, networkClient: StatisticsNetworkClientProtocol = StatisticsNetworkClient()) {
        self.view = view
        self.networkClient = networkClient
    }
    
    func fetchData() {
        DispatchQueue.main.async { [weak self] in
            self?.view?.showActivityIndicator()
        }
        
        guard let url = URL(string: "\(RequestConstants.baseURL)/api/v1/users") else {
            print("Invalid URL")
            return
        }
        
        _ = networkClient.fetchData(from: url) { [weak self] result in
            defer {
                DispatchQueue.main.async { [weak self] in
                    self?.view?.hideActivityIndicator()
                }
            }
            switch result {
            case .success(let data):
                self?.handleSuccess(data: data)
                
            case .failure(let error):
                self?.handleFailure(error: error)
            }
        }
    }
    
    private func handleSuccess(data: Data) {
        do {
            let usersList = try JSONDecoder().decode(UsersList.self, from: data)
            let dummyUsers = usersList.enumerated().map { index, element in
                let userModel = UserModel(
                    avatar: element.avatar,
                    username: element.name,
                    nftCount: "\(element.nfts.count)",
                    description: element.description,
                    website: element.website,
                    rating: element.rating
                )
                return userModel
            }
            
            DispatchQueue.main.async { [weak self] in
                let sortedUsers = dummyUsers.sorted { (user1, user2) -> Bool in
                    if let rating1 = user1.rating, let rating2 = user2.rating {
                        return rating1 > rating2
                    } else {
                        return false
                    }
                }
                self?.view?.updateUsers(users: sortedUsers)
            }
            
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
    
    private func handleFailure(error: Error) {
        print("Error fetching data: \(error)")
        
        // TODO: Реализовать логику отображения Alert с ошибкой
    }
    
    func sortUsersByRating() {
        users.sort { (user1, user2) -> Bool in
            if let rating1 = user1.rating, let rating2 = user2.rating {
                return rating1 > rating2
            } else {
                return false
            }
        }
        view?.updateUsers(users: users)
    }
    
    func sortUsersByName() {
        users.sort { (user1, user2) -> Bool in
            if let name1 = user1.username, let name2 = user2.username {
                return name1.localizedCaseInsensitiveCompare(name2) == .orderedAscending
            } else {
                return false
            }
        }
        view?.updateUsers(users: users)
    }
    
    func updateUsers(users: [UserModel]) {
        self.users = users
    }
    
    func numberOfUsers() -> Int {
        return users.count
    }
    
    func user(at index: Int) -> UserModel {
        return users[index]
    }
}
