//
//  File.swift
//  FakeNFT
//
//  Created by Андрей Асланов on 22.12.23.
//

import UIKit        //Это относится к части statistics2-3, сверстал чтобы проверить работу перехода

final class UserNftCollectionViewController: UIViewController {
    
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                     style: .plain, target: self,
                                     action: #selector(leftBarButtonItemTapped))
        button.tintColor = .black
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        setupUI()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Коллекция NFT"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)
        ]
        
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupUI() {
        
    }
    
    @objc private func leftBarButtonItemTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension UserNftCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return UICollectionViewCell()
    }
    
}
