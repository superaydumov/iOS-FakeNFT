//
//  CatalogServices.swift
//  FakeNFT
//
//  Created by Ян Максимов on 13.12.2023.
//

import UIKit

enum CatalogServiceError: Error {
    case networkError(NetworkClientError)
    case invalidURL
}

final class CatalogServices {
    
    var collections: [NFTCollectionInfo] = []
    
    private let defaultNetworkClient = DefaultNetworkClient()
    private let loadLimit = 10
    private var isCurrentlyLoading: Bool = false
    private var areAllCollectionsDownloaded: Bool = false
    var isAllCollectionsDownloaded: Bool {
        return areAllCollectionsDownloaded
    }
    var currentlyLoading: Bool {
        return isCurrentlyLoading
    }
    
    // MARK: Fetch Collections
    func fetchCollections(completion: @escaping (Result<Bool, Error>) -> Void) {
        guard !isCurrentlyLoading, !areAllCollectionsDownloaded else { return }
        
        if let url = URL(string: "\(RequestConstants.baseURL)/api/v1/collections") {
            let catalogRequest = CatalogRequest(endpoint: url, httpMethod: .get)
            
            isCurrentlyLoading = true
            
            defaultNetworkClient.send(request: catalogRequest, type: [NFTCollection].self) { [weak self] result in
                switch result {
                case .success(let collections):
                    self?.handleNetworkResponse(.success(collections), completion: completion)
                case .failure(let error):
                    if let networkError = error as? NetworkClientError {
                        completion(.failure(CatalogServiceError.networkError(networkError)))
                    } else {
                        // Обработка случаев, когда ошибка не является NetworkClientError
                        completion(.failure(error))
                    }
                }
                self?.isCurrentlyLoading = false // Вызов сброса флага загрузки после завершения запроса
            }
        } else {
            // Обработка ошибки некорректного URL-адреса
            completion(.failure(CatalogServiceError.invalidURL))
            self.isCurrentlyLoading = false // Сброс флага загрузки в случае ошибки URL
        }
    }
    
    // MARK: Handle Network Response
    private func handleNetworkResponse(_ result: Result<[NFTCollection], Error>,
                                       completion: @escaping (Result<Bool, Error>) -> Void) {
        DispatchQueue.main.async {
            [weak self] in
            switch result {
            case .success(let collections):
                self?.updateCollections(collections, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
            self?.isCurrentlyLoading = false
        }
    }
    
    // MARK: Update Collections
    private func updateCollections(_ data: [NFTCollection],
                                   completion: @escaping (Result<Bool, Error>) -> Void) {
        let collectionsResult = data.map({ NFTCollectionInfo(fromNFTCollection: $0) })
        if collectionsResult.count < loadLimit {
            areAllCollectionsDownloaded = true
        }
        collections.append(contentsOf: collectionsResult)
        completion(.success(true))
        NotificationCenter.default.post(name: CatalogPresenter.didChangeCollectionsListNotification, object: self)
    }
}
