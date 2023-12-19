//
//  Protocols.swift
//  FakeNFT
//
//  Created by Ян Максимов on 19.12.2023.
//

import UIKit

protocol CatalogView: AnyObject {
    var catalogPresenter: CatalogPresenterProtocol { get set }
    func reloadCatalogTableView()
    func addRowsToCatalogTableView(indexPaths: [IndexPath])
    func displayAlert(title: String, message: String?, actions: [UIAlertAction])
}

protocol CatalogPresenterProtocol {
    var catalogView: CatalogView? { get set }
    var collections: [NFTCollectionInfo] { get }
    func onViewDidLoad()
    func handleFilterButtonTap()
    func applyFiltering()
    func willDisplayCell(_ indexPath: IndexPath)
    func setUserDefaultsData(by type: Int, for key: String)
}

protocol AlertPresenterDelegate: AnyObject {
    func presentAlertController(_ alertController: UIAlertController)
}
