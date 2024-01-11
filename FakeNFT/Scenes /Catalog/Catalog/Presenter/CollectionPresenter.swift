//
//  CollectionPresenter.swift
//  FakeNFT
//
//  Created by Ян Максимов on 26.12.2023.
//

import Foundation

protocol CollectionPresenterProtocol {
    var view: CollectionViewControllerProtocol? { get }
    var collection: NFTCollectionInfo { get }
    var authorProfile: UserModel? { get }
    var nfts: [NFTInformation] { get }

    func viewDidLoad()
    func refreshData()
    func isLikedNFT(_ id: String) -> Bool
    func isInCart(_ id: String) -> Bool
    func setLikeForNFT(_ id: String)
    func addNFTToCart(_ id: String)
}

final class CollectionPresenter: CollectionPresenterProtocol {

    // MARK: - Constants
    private enum ErrorMessages {
        static let loadError = "Ошибка загрузки. Повторить?"
        static let likeError = "Не удалось поставить лайк"
        static let cartError = "Не удалось добавить в корзину"
    }

    // MARK: - Public Properties
    let collection: NFTCollectionInfo
    var likes: [String] = []
    var orders: [String] = []
    var nfts: [NFTInformation] = []
    var authorProfile: UserModel?
    weak var view: CollectionViewControllerProtocol?

    // MARK: - Private Properties
    private var showError: Bool = false
    private let service = CatalogServices()

    // MARK: - Lifecycle
    init(collection: NFTCollectionInfo) {
        self.collection = collection
    }

    // MARK: - Public Methods
    @objc func viewDidLoad() {
        UIBlockingProgressHUD.show()
        showError = false
        refreshData()
    }

    func refreshData() {
        showError = false
        let tasks = [loadCollectionAuthor, loadLikes, fetchNFTS, loadOrders]
        performTasks(tasks, completion: handleLoadCompletion)
    }

    func setLikeForNFT(_ id: String) {
        var updatedLikes = self.likes
        if updatedLikes.contains(id) {
            updatedLikes.removeAll { $0 == id }
        } else {
            updatedLikes.append(id)
        }
        self.likes = updatedLikes
        uploadLikes()

        DispatchQueue.main.async { [weak self] in
            self?.view?.updateData()
        }
    }

    func addNFTToCart(_ id: String) {
        var updatedCart = self.orders
        if updatedCart.contains(id) {
            updatedCart.removeAll { $0 == id }
        } else {
            updatedCart.append(id)
        }
        self.orders = updatedCart
        uploadCart()
    }

    func isLikedNFT(_ id: String) -> Bool {
        likes.contains(id)
    }

    func isInCart(_ id: String) -> Bool {
        orders.contains(id)
    }

    // MARK: - Private Methods
    private func performTasks(_ tasks: [(@escaping () -> Void) -> Void], completion: @escaping () -> Void) {
        let group = DispatchGroup()
        tasks.forEach { task in
            group.enter()
            task { group.leave() }
        }
        group.notify(queue: .main, execute: completion)
    }

    private func handleLoadCompletion() {
        if showError {
            view?.showErrorAlert(ErrorMessages.loadError, repeatAction: #selector(viewDidLoad), target: self)
        } else {
            view?.updateData()
        }
        UIBlockingProgressHUD.dismiss()
    }

    private func updateList(_ list: inout [String],
                            with id: String,
                            errorMessage: String,
                            updateAction: @escaping () -> Void) {
        if list.contains(id) {
            list.removeAll { $0 == id }
        } else {
            list.append(id)
        }
        updateAction()
    }

    private func fetchNFTS(completion: @escaping () -> Void) {
        service.fetchNFTS(collection.nfts) { [weak self] result in
            switch result {
            case .success(let nfts):
                self?.nfts = nfts
            case .failure:
                self?.showError = true
            }
            completion()
        }
    }

    private func loadCollectionAuthor(completion: @escaping () -> Void) {
        // Используем моковые данные для пользователя
        let mockUserResult = UserResult(id: "1",
                                        name: "John Doe",
                                        website: "https://practicum.yandex.ru/ios-developer/?from=catalog",
                                        avatar: nil,
                                        description: "Mock user description",
                                        nfts: [],
                                        rating: "5.0")
        let mockUserModel = UserModel(userResult: mockUserResult)
        self.authorProfile = mockUserModel
        completion()
    }

    private func loadLikes(completion: @escaping () -> Void) {
        service.loadProfile { [weak self] result in
            switch result {
            case .success(let profile):
                self?.likes = profile.likes
            case .failure:
                self?.showError = true
            }
            completion()
        }
    }

    private func loadOrders(completion: @escaping () -> Void) {
        service.loadCart { [weak self] result in
            switch result {
            case .success(let cart):
                self?.orders = cart.nfts
            case .failure:
                self?.showError = true
            }
            completion()
        }
    }

    @objc private func uploadLikes() {
        UIBlockingProgressHUD.show()

        service.uploadLikes(likes: self.likes) { [weak self] result in
            switch result {
            case .success(let profile):
                guard !profile.likes.isEmpty  else { return }
                self?.likes = profile.likes
                DispatchQueue.main.async {
                    self?.view?.updateData()
                }
            case .failure:
                DispatchQueue.main.async {
                    self?.view?.showErrorAlert(ErrorMessages.likeError,
                                               repeatAction: #selector(self?.uploadLikes),
                                               target: self)
                }
            }
            UIBlockingProgressHUD.dismiss()
        }
    }

    @objc private func uploadCart() {
        UIBlockingProgressHUD.show()

        service.uploadOrders(orders: self.orders) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success(let cart):
                guard !cart.nfts.isEmpty else { return }
                self?.orders = cart.nfts
                DispatchQueue.main.async {
                    self?.view?.updateData()
                }
            case .failure:
                DispatchQueue.main.async {
                    self?.view?.showErrorAlert(ErrorMessages.cartError,
                                               repeatAction: #selector(self?.uploadCart),
                                               target: self)
                }
            }
        }
    }
}
