//
//  CatalogCell.swift
//  FakeNFT
//
//  Created by Ян Максимов on 11.12.2023.
//

import UIKit

final class CatalogCell: UITableViewCell, ReuseIdentifying {
    
    // MARK: - Public Properties
    var collectionImageView: UIImageView {
        get { collectionPicture }
        set { collectionPicture = newValue }
    }
    
    var collectionLabelView: UILabel {
        get { collectionLabel }
        set { collectionLabel = newValue }
    }
    
    // MARK: - Private Properties
    private lazy var collectionPicture: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var collectionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .bodyBold
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupSubviews() {
        addSubviews()
        constraintSubviews()
        configureAppearance()
    }
    
    private func addSubviews() {
        contentView.addSubview(collectionPicture)
        contentView.addSubview(collectionLabel)
    }
    
    private func constraintSubviews() {
        NSLayoutConstraint.activate([
            collectionPicture.heightAnchor.constraint(equalToConstant: 140),
            collectionPicture.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionPicture.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionPicture.topAnchor.constraint(equalTo: topAnchor),
            collectionPicture.bottomAnchor.constraint(equalTo: collectionLabel.topAnchor, constant: -4),
            
            collectionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionLabel.topAnchor.constraint(equalTo: collectionPicture.bottomAnchor, constant: 4),
            collectionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -21),
        ])
    }
    
    private func configureAppearance() {
        backgroundColor = .white
        selectionStyle = .none
    }
}
