//
//  StatisticsTableViewCell.swift
//  FakeNFT
//
//  Created by Андрей Асланов on 10.12.23.
//

import UIKit

class StatisticsTableViewCell: UITableViewCell {
    private let rankLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 14
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .black
        return label
    }()

    private let nftCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .black
        return label
    }()
    
    private let grayBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.yaLightGrayLight
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Устанавливаем закругление ячейки
        grayBackgroundView.layer.cornerRadius = 12
        grayBackgroundView.layer.masksToBounds = true
    }

    private func setupSubviews() {
        addSubview(rankLabel)
        addSubview(grayBackgroundView)
        grayBackgroundView.addSubview(avatarImageView)
        grayBackgroundView.addSubview(usernameLabel)
        grayBackgroundView.addSubview(nftCountLabel)

        NSLayoutConstraint.activate([
            
            rankLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            rankLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            rankLabel.widthAnchor.constraint(equalToConstant: 20),
            rankLabel.heightAnchor.constraint(equalToConstant: 27),

            grayBackgroundView.leadingAnchor.constraint(equalTo: rankLabel.trailingAnchor, constant: 8),
            grayBackgroundView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            grayBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            grayBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            grayBackgroundView.heightAnchor.constraint(equalToConstant: 80),
            
            avatarImageView.leadingAnchor.constraint(equalTo: grayBackgroundView.leadingAnchor, constant: 16),
            avatarImageView.centerYAnchor.constraint(equalTo: grayBackgroundView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 28),
            avatarImageView.heightAnchor.constraint(equalToConstant: 28),

            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            usernameLabel.centerYAnchor.constraint(equalTo: grayBackgroundView.centerYAnchor),

            nftCountLabel.leadingAnchor.constraint(equalTo: usernameLabel.trailingAnchor, constant: 8),
            nftCountLabel.trailingAnchor.constraint(equalTo: grayBackgroundView.trailingAnchor, constant: -16),
            nftCountLabel.centerYAnchor.constraint(equalTo: grayBackgroundView.centerYAnchor),
        ])
    }

//    func configure(with user: UserModel, at index: Int) {     //если вернут base64
//        rankLabel.text = "\(index + 1)"
//        avatarImageView.image = user.decodeAvatar() ?? UIImage(named: "userplaceholder")
//        usernameLabel.text = user.username
//        nftCountLabel.text = "\(user.nftCount)"
//    }
    
    func configure(with user: UserModel, at index: Int) {
        rankLabel.text = "\(index + 1)"
        
        if let avatarURL = URL(string: user.avatar ?? "") {
            avatarImageView.kf.setImage(with: avatarURL, placeholder: UIImage(named: "userplaceholder"))
        } else {
            avatarImageView.image = UIImage(named: "userplaceholder")
        }

        usernameLabel.text = user.username
        nftCountLabel.text = "\(user.nftCount)"
    }
}
