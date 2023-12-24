//
//  NftCollectionViewCell.swift
//  FakeNFT
//
//  Created by Андрей Асланов on 22.12.23.
//

import UIKit    //Это относится к части statistics3-3, сверстал чтобы проверить работу перехода

final class NftCollectionViewCell: UICollectionViewCell {
    
    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let ratingView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 2
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private let cartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "cart"), for: .normal)
        return button
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        return button
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
        [nftImageView,
        ratingView,
        titleLabel,
        priceLabel,
        cartButton,
        likeButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nftImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            nftImageView.topAnchor.constraint(equalTo: topAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            nftImageView.heightAnchor.constraint(equalTo: nftImageView.widthAnchor),
            
            ratingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            ratingView.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 8),
            
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            
            cartButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            cartButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            
            likeButton.leadingAnchor.constraint(equalTo: cartButton.trailingAnchor, constant: 8),
            likeButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
        ])
    }
    
    func configure(with nftImage: UIImage?, rating: Int, title: String, price: Float) {
        nftImageView.image = nftImage
        setupRatingStars(rating: rating)
        titleLabel.text = title
        priceLabel.text = String(format: "$%.2f", price)
    }
    
    private func setupRatingStars(rating: Int) {
        for i in 0..<5 {
            let starImageView = UIImageView()
            starImageView.image = UIImage(systemName: i < rating ? "star.fill" : "star")
            starImageView.tintColor = i < rating ? .systemYellow : .systemGray
            starImageView.contentMode = .scaleAspectFit
            ratingView.addArrangedSubview(starImageView)
        }
    }
}
