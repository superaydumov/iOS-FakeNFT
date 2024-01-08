//
//  CatalogPresenter.swift
//  FakeNFT
//
//  Created by Ян Максимов on 11.12.2023.
//

import UIKit

final class CatalogPresenter: CatalogPresenterProtocol {
    
    // MARK: - Public Properties
    weak var view: CatalogView?
    private (set) var collections: [NFTCollectionInfo] = []
    static let didChangeCollectionsListNotification = Notification.Name(rawValue: "ChangeCollectionsList")
    
    // MARK: - Private Properties
    private let service = CatalogServices()
    private let userDefaults = UserDefaults.standard
    private let catalogFilterTypeKey = "CatalogFilterType"
    
    // MARK: - Initializer
    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateCollectionsList),
                                               name: CatalogPresenter.didChangeCollectionsListNotification,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Public Methods
    func onViewDidLoad() {
        UIBlockingProgressHUD.show()
        loadCollections()
    }
    
    func viewDidDisappear() {
        NotificationCenter.default.removeObserver(self,
                                                  name: CatalogPresenter.didChangeCollectionsListNotification,
                                                  object: nil)
    }
    
    func applyFiltering() {
        let filterTypeInt = userDefaults.integer(forKey: catalogFilterTypeKey)
        let filterType = FilterType(rawValue: filterTypeInt)
        switch filterType {
        case .byName:
            self.collections.sort { $0.name < $1.name }
        case .NFTcount:
            self.collections.sort { $0.nfts.count > $1.nfts.count }
        default:
            let alertController = UIAlertController(title: "Ошибка",
                                                    message: "Неизвестный тип фильтра",
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK",
                                                    style: .default,
                                                    handler: nil))
            break
        }
        view?.reloadCatalogTableView()
    }
    
    func handleFilterButtonTap() {
        applyFiltering()
    }
    
    func willDisplayCell(_ indexPath: IndexPath) {
        if indexPath.row == (collections.count - 1) {
            loadCollections()
        }
    }
    
    func setUserDefaultsData(by type: Int, for key: String) {
        userDefaults.set(type, forKey: catalogFilterTypeKey)
    }
    
    // MARK: - Private Methods
    private func loadCollections() {
        service.fetchCollections { [weak self] result in
            DispatchQueue.main.async {
                UIBlockingProgressHUD.dismiss()
                switch result {
                case .success(_):
                    self?.view?.reloadCatalogTableView()
                case .failure(let error):
                    self?.view?.displayAlert(title: "Error",
                                             message: error.localizedDescription,
                                             actions: [UIAlertAction(title: "OK", style: .default)])
                }
            }
        }
    }
    
    @objc private func updateCollectionsList() {
        collections = service.collections
        view?.reloadCatalogTableView()
    }
}

// MARK: - FilterType Enum
enum FilterType: Int {
    case byName
    case NFTcount
}
