//
//  StatisticsPresenter.swift
//  FakeNFT
//
//  Created by Андрей Асланов on 10.12.23.
//

import Foundation

protocol StatisticsView: AnyObject {
    func updateUsers(users: [UserModel])
    func showActivityIndicator()
    func hideActivityIndicator()
}

import Foundation

class StatisticsPresenter {
    private weak var view: StatisticsView?
    var users: [UserModel] = []
    var defaultNetworkClient = DefaultNetworkClient()

    init(view: StatisticsView) {
        self.view = view
    }
    
    func fetchData() {
        DispatchQueue.main.async {
            self.view?.showActivityIndicator()
        }
        getDataUser { [weak self] result in
            defer {
                DispatchQueue.main.async {
                    self?.view?.hideActivityIndicator()
                }
            }
            switch result {
            case .success(let data):
                print("Received data: \(data.count) bytes")

                do {
                    // Декодирование JSON
                    let usersList = try JSONDecoder().decode(UsersList.self, from: data)
                    print("Decoded usersList: \(usersList)")
                    
                    let dummyUsers = usersList.enumerated().map { index, element in
                        print("Original name for user \(index + 1): \(element.name)")
                        
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

                    print("Dummy users: \(dummyUsers)")
                    
                    DispatchQueue.main.async {      // Сортировка по рейтингу по умолчанию
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

            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }
    }
    
    func getDataUser(completion: @escaping (Result<Data, Error>) -> Void) -> URLRequest? {
        guard let url = URL(string: "\(RequestConstants.baseURL)/api/v1/users") else {
            print("Invalid URL")
            return nil
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"

        urlRequest.setValue("\(RequestConstants.accessToken)", forHTTPHeaderField: "X-Practicum-Mobile-Token")

        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
            }

            if let data = data {
                completion(.success(data))
            } else {
                let noDataError = NSError(domain: "NoData", code: 0, userInfo: nil)
                completion(.failure(noDataError))
            }
        }
        task.resume()
        return urlRequest
    }
    
    // Сортировка по рейтингу
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

    // Сортировка по имени
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

    func numberOfUsers() -> Int {
        return users.count
    }

    func user(at index: Int) -> UserModel {
        return users[index]
    }
}
