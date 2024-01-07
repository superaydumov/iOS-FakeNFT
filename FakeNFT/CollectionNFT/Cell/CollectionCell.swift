//
//  CollectionCell.swift
//  FakeNFT
//
//  Created by Ян Максимов on 07.01.2024.
//

import UIKit
import Kingfisher

// TODO: Дальнейшая реализация загрузки списка нфт, а именно отображение изображения согласно макету, название, цена, рейтинг и кнопки добавления в избранное и корзину должна быть реализованы в 3 эпике.
class NFTCell: UICollectionViewCell {
    
    // MARK: - Private Properties
    private lazy var nftImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.heightAnchor.constraint(equalTo: image.widthAnchor, multiplier: 1).isActive = true
        image.layer.cornerRadius = 12
        image.layer.masksToBounds = true
        return image
    }()
    
    var viewModel: NFTInformation? {
        didSet {
            guard let viewModel = viewModel else { return }
            setupViewModel(viewModel: viewModel)
        }
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        backgroundColor = .white
        addSubview(nftImage)
        NSLayoutConstraint.activate([
            nftImage.topAnchor.constraint(equalTo: topAnchor),
            nftImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            nftImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            nftImage.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    private func setupViewModel(viewModel: NFTInformation) {
        DispatchQueue.main.async {
            self.nftImage.kf.indicatorType = .activity
            self.nftImage.kf.setImage(with: viewModel.image)
        }
    }
}

