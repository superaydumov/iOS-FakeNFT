//
//  CatalogPresenter.swift
//  FakeNFT
//
//  Created by Ян Максимов on 11.12.2023.
//

import UIKit

final class CatalogPresenter: CatalogPresenterProtocol {
    
    // MARK: - Public Properties
    weak var catalogView: CatalogView?
    private (set) var collections: [NFTCollectionInfo] = []
    static let didChangeCollectionsListNotification = Notification.Name(rawValue: "ChangeCollectionsList")
    
    // MARK: - Private Properties
    private let service = CatalogServices()
    private let userDefaults = UserDefaults.standard
    private let catalogFilterTypeKey = "CatalogFilterType"
    
    // MARK: - Public methods
    func onViewDidLoad() {
        // MARK: View Lifecycle - onViewDidLoad
        UIBlockingProgressHUD.show()
        NotificationCenter.default
            .addObserver(forName: CatalogPresenter.didChangeCollectionsListNotification, object: nil, queue: .main) { [weak self] _ in
                guard let self = self else { return }
                self.updateTableView(animated: true)
                self.applyFiltering()
                UIBlockingProgressHUD.dismiss()
            }
        loadCollections()
    }
    
    func applyFiltering() {
        // MARK: Filtering
        let filterTypeInt = userDefaults.integer(forKey: catalogFilterTypeKey)
        let filterType = FilterType(rawValue: filterTypeInt)
        switch filterType {
        case .byName:
            self.collections = collections.sorted(by: { $0.name < $1.name })
        case .NFTcount:
            self.collections = collections.sorted(by: { $0.nfts.count > $1.nfts.count })
        default:
            break
        }
        updateTableView(animated: false)
    }
    
    func handleFilterButtonTap() {
        applyFiltering()
    }
    
    func willDisplayCell(_ indexPath: IndexPath) {
        if indexPath.row == (self.collections.count) - 1 {
            loadCollections()
        }
    }
    
    func setUserDefaultsData(by type: Int, for key: String) {
        self.userDefaults.setValue(type, forKey: catalogFilterTypeKey)
    }
    
    // MARK: - Private methods
    private func updateTableView(animated: Bool) {
        guard animated else {
            catalogView?.reloadCatalogTableView()
            return
        }
        let oldCount = collections.count
        let newCount = service.collections.count
        collections = service.collections
        if oldCount != newCount {
            let indexPaths = (oldCount..<newCount).map { row in
                IndexPath(row: row, section: 0)
            }
            catalogView?.addRowsToCatalogTableView(indexPaths: indexPaths)
        }
    }
    
    private func loadCollections() {
        service.fetchCollections { [weak self] result in
            switch result {
            case .success(_):
                break
            case .failure(let errorForAlert):
                let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                    // Перезагрузка коллекции после нажатия на кнопку "OK"
                    self?.loadCollections()
                }
                self?.catalogView?.displayAlert(title: "Error", message: errorForAlert.localizedDescription, actions: [okAction])
            }
        }
    }
}

// MARK: - Enums
enum FilterType: Int {
    case byName
    case NFTcount
}
