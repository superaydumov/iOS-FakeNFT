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
    
    private let userId: String = "1"
    var collections: [NFTCollectionInfo] = []
    
    private let defaultNetworkClient = DefaultNetworkClient()
    private let loadLimit = 10
    private var isCurrentlyLoading: Bool = false
    private var areAllCollectionsDownloaded: Bool = false
    
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
                        completion(.failure(error))
                    }
                }
                self?.isCurrentlyLoading = false
            }
        } else {
            completion(.failure(CatalogServiceError.invalidURL))
            self.isCurrentlyLoading = false
        }
    }
    
    func loadUser(_ id: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        guard !isCurrentlyLoading else {
            completion(.failure(CatalogServiceError.networkError(.urlSessionError)))
            return
        }
        
        let url = URL(string: "\(RequestConstants.baseURL)/api/v1/users/\(id)")
        guard let requestUrl = url else {
            completion(.failure(CatalogServiceError.invalidURL))
            return
        }
        
        let catalogRequest = CatalogRequest(endpoint: requestUrl, httpMethod: .get)
        
        isCurrentlyLoading = true
        
        defaultNetworkClient.send(request: catalogRequest, type: UserResult.self) { [weak self] result in
            defer { self?.isCurrentlyLoading = false }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    completion(.success(UserModel(userResult: data)))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func loadProfile(completion: @escaping (Result<ProfileModel, Error>) -> Void) {
        let url = URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
        
        defaultNetworkClient.send(request: CatalogRequest(endpoint: url, httpMethod: .get), type: ProfileResult.self) { result in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    completion(.success(ProfileModel(profileResult: data)))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchNFTS(_ ids: [String], completion: @escaping (Result<[NFTInformation], Error>) -> Void) {
        let url = URL(string: "\(RequestConstants.baseURL)/api/v1/nft")
        
        defaultNetworkClient.send(request: CatalogRequest(endpoint: url), type: [NFTItem].self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    let filteredData = data.filter { ids.contains($0.id) }.map(NFTInformation.init)
                    completion(.success(filteredData))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: Handle Network Response
    private func handleNetworkResponse(
        _ result: Result<[NFTCollection], Error>,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        DispatchQueue.main.async { [weak self] in
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
    private func updateCollections(
        _ data: [NFTCollection],
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        let collectionsResult = data.map({ NFTCollectionInfo(fromNFTCollection: $0) })
        if collectionsResult.count < loadLimit {
            areAllCollectionsDownloaded = true
        }
        collections.append(contentsOf: collectionsResult)
        completion(.success(true))
        NotificationCenter.default.post(name: CatalogPresenter.didChangeCollectionsListNotification, object: self)
    }
}
