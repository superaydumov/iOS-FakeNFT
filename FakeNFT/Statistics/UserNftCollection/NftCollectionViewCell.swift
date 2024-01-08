//
//  NftCollectionViewCell.swift
//  FakeNFT
//
//  Created by Андрей Асланов on 22.12.23.
//

import UIKit
import Kingfisher

final class NftCollectionViewCell: UICollectionViewCell {
    
    var likeButtonTappedHandler: (() -> Void)?
    var cartButtonTappedHandler: (() -> Void)?
    
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var ratingView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        return label
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "likeButtonOff"), for: .normal)
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "addToBasket"), for: .normal)
        button.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc private func likeButtonTapped() {
        likeButton.isSelected = !likeButton.isSelected
        likeButtonTappedHandler?()

        if let currentImage = likeButton.imageView?.image,
           let likeButtonOnImage = UIImage(named: "likeButtonOn"),
           let likeButtonOffImage = UIImage(named: "likeButtonOff") {

            if currentImage == likeButtonOnImage {
                likeButton.setImage(likeButtonOffImage, for: .normal)
            } else {
                likeButton.setImage(likeButtonOnImage, for: .normal)
            }
        }
    }
    
    @objc private func cartButtonTapped() {
        cartButton.isSelected = !cartButton.isSelected
        cartButtonTappedHandler?()

        if let currentImage = cartButton.imageView?.image,
            let addToBasketImage = UIImage(named: "addToBasket"),
            let deleteFromBasketImage = UIImage(named: "deleteFromBasket") {

            if currentImage == addToBasketImage {
                cartButton.setImage(deleteFromBasketImage, for: .normal)
            } else {
                cartButton.setImage(addToBasketImage, for: .normal)
            }
        }
    }
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [nftImageView, stackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
                
        [likeButton, cartButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        [ratingView, titleLabel, priceLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            
            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: -6),
            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 6),
            likeButton.heightAnchor.constraint(equalToConstant: 42),
            likeButton.widthAnchor.constraint(equalToConstant: 42),
            
            cartButton.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 24),
            cartButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            cartButton.heightAnchor.constraint(equalToConstant: 40),
            cartButton.widthAnchor.constraint(equalToConstant: 40),
            
            stackView.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 68),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])

        // Констрейнты для элементов внутри stackView
        NSLayoutConstraint.activate([
            ratingView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            ratingView.topAnchor.constraint(equalTo: stackView.topAnchor),
            ratingView.widthAnchor.constraint(equalToConstant: 62),
            ratingView.heightAnchor.constraint(equalToConstant: 12),
            
            titleLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 5),
            titleLabel.widthAnchor.constraint(equalToConstant: 68),
            
            priceLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
        ])
    }
    
    func configure(with nft: NftModel, isLiked: Bool, isInCart: Bool) {
        if let imageUrl = nft.images?.first, let url = URL(string: imageUrl.absoluteString) {
            nftImageView.kf.setImage(with: url)
        } else {
            nftImageView.image = UIImage(named: "placeholder")
        }
        
        setupRatingStars(rating: nft.rating ?? 0)
        titleLabel.text = nft.name
        priceLabel.text = String(format: "%.2f ETH", nft.price ?? 0)

        let likeButtonOnImage = UIImage(named: "likeButtonOn")
        let likeButtonOffImage = UIImage(named: "likeButtonOff")
        let cartButtonAddImage = UIImage(named: "addToBasket")
        let cartButtonRemoveImage = UIImage(named: "deleteFromBasket")

        if isLiked {
            likeButton.setImage(likeButtonOnImage, for: .normal)
        } else {
            likeButton.setImage(likeButtonOffImage, for: .normal)
        }
        
        if isInCart {
            cartButton.setImage(cartButtonRemoveImage, for: .normal)
        } else {
            cartButton.setImage(cartButtonAddImage, for: .normal)
        }
    }
    
    private func setupRatingStars(rating: Int) {
        for i in 0..<5 {
            let starImageView = UIImageView()
            starImageView.image = UIImage(systemName: "star.fill")
            starImageView.tintColor = i < rating ? .systemYellow : .yaLightGrayLight
            starImageView.contentMode = .scaleAspectFit
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            ratingView.addSubview(starImageView)

            NSLayoutConstraint.activate([
                starImageView.widthAnchor.constraint(equalToConstant: 12),
                starImageView.heightAnchor.constraint(equalToConstant: 12),
                starImageView.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor),
                starImageView.leadingAnchor.constraint(equalTo: ratingView.leadingAnchor, constant: CGFloat(i * 14))
            ])
        }
    }
}
