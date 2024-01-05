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
    var authorProfile: UserModel? = nil
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
        
        let tasks = [loadCollectionAuthor, loadLikes, loadNFTS]
        performTasks(tasks, completion: handleLoadCompletion)
    }
    
    // TODO: реализовать в 3 эпике
    func setLikeForNFT(_ id: String) {
        
    }
    
    // TODO: реализовать в 3 эпике
    func addNFTToCart(_ id: String) {
        
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
    
    private func updateList(_ list: inout [String], with id: String, errorMessage: String, updateAction: @escaping () -> Void) {
        if list.contains(id) {
            list.removeAll { $0 == id }
        } else {
            list.append(id)
        }
        updateAction()
    }
    
    private func loadNFTS(completion: @escaping () -> Void) {
        service.loadNFTS(collection.nfts) { [ weak self ] result in
            switch result {
            case .success(let nfts):
                self?.nfts = nfts
            case .failure(let error):
                print("Error loading NFTs: \(error)")
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
        service.loadProfile { [ weak self ] result in
            switch result {
            case .success(let profile):
                self?.likes = profile.likes
            case .failure(let error):
                self?.showError = true
            }
            completion()
        }
    }
}
